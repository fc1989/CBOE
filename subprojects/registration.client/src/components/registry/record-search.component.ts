import {
  Component,
  Input,
  Output,
  EventEmitter,
  ChangeDetectionStrategy,
  OnInit, OnDestroy, OnChanges,
  ElementRef, ChangeDetectorRef,
  ViewChildren, QueryList, ViewChild
} from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { Subscription } from 'rxjs/Subscription';
import { select, NgRedux } from '@angular-redux/store';
import { DxFormComponent } from 'devextreme-angular';
import * as searchTypes from './registry-search.types';
import { CViewGroup, ISearchCriteriaItem } from './base';
import { RegistrySearchActions, IAppState, ISearchRecords, IQueryData, ILookupData } from '../../redux';
import { Router, ActivatedRoute } from '@angular/router';
import { ChemDrawWeb } from '../common';
import { FormGroupType, prepareFormGroupData, IFormGroup, notify } from '../../common';
import * as X2JS from 'x2js';

declare var jQuery: any;

@Component({
  selector: 'reg-record-search',
  styles: [require('./records.css')],
  template: require('./record-search.component.html'),
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class RegRecordSearch implements OnInit, OnDestroy, OnChanges {
  @Input() temporary: boolean;
  @Input() parentHeight: string;
  @Input() activated: boolean;
  @Output() onClose = new EventEmitter<any>();
  @select(s => s.session.lookups) lookups$: Observable<any>;
  @ViewChild(ChemDrawWeb) private chemDrawWeb: ChemDrawWeb;
  public formGroup: IFormGroup;
  private lookups: ILookupData;
  private lookupsSubscription: Subscription;
  private searchItems: ISearchCriteriaItem[] = [];
  private viewGroups: CViewGroup[] = [];
  private title: string;
  private displayMode: string = 'query';
  private cddActivated: boolean = false;

  constructor(
    private router: Router,
    private elementRef: ElementRef,
    private changeDetector: ChangeDetectorRef,
    private ngRedux: NgRedux<IAppState>,
    private actions: RegistrySearchActions) {
  }

  ngOnInit() {
    this.title = this.temporary ? 'Search Temporary Records' : 'Search Permanent Registry';
    // this.regSearch = new searchTypes.CSearchFormVM(this.temporary, this.ngRedux.getState());
    this.lookupsSubscription = this.lookups$.subscribe(d => { if (d) { this.loadData(d); } });
  }

  ngOnDestroy() {
    if (this.lookupsSubscription) {
      this.lookupsSubscription.unsubscribe();
    }
  }

  loadData(lookups: ILookupData) {
    this.lookups = lookups;
    let formGroupType = this.temporary ? FormGroupType.SearchTemporary : FormGroupType.SearchPermanent;
    prepareFormGroupData(formGroupType, this.ngRedux);
    let state = this.ngRedux.getState();
    this.formGroup = state.configuration.formGroups[FormGroupType[formGroupType]] as IFormGroup;
    this.viewGroups = this.lookups ? CViewGroup.getViewGroups(this.formGroup, this.displayMode, this.lookups.disabledControls) : [];
    this.setSearchItems();
    this.update();
  }

  ngOnChanges() {
    this.update(false);
  }

  private setSearchItems() {
    this.searchItems = [];
    this.viewGroups.forEach(vg => {
      let items = vg.getSearchItems();
      items.forEach(i => {
        this.searchItems.push(i);
      });
    });
  }

  private update(forceUpdate: boolean = true) {
    // Don't keep changing cdd configuration
    if (!this.cddActivated && this.activated) {
      this.cddActivated = true;
    }
    if (forceUpdate) {
      this.changeDetector.markForCheck();
    }
  }

  private generateSearchCriteriaXML(): string {
    let searchCriteria = `<?xml version="1.0" encoding="UTF-8"?><searchCriteria xmlns="COE.SearchCriteria">`;
    // for (let key in this.searchCriteria) {
    //   if (this.searchCriteria[key]) {
    //     searchCriteria += new X2JS.default().js2xml({ searchCriteriaItem: this.searchCriteria[key] });
    //   }
    // }
    return searchCriteria + '</searchCriteria>';
  }

  private search() {
    let queryData: IQueryData = {
      temporary: this.temporary,
      searchCriteria: this.generateSearchCriteriaXML()
    };
    this.actions.searchRecords(queryData);
  }

  private get x2jsTool() {
    return new X2JS.default({
      arrayAccessFormPaths: [
        'searchCriteria.searchCriteriaItem',
      ]
    });
  }

  private fillSearchCriteriaFromXML(queryXml: string) {
    // This is to compensate bug in the server implementation.
    // Sometimes the XML contents are not properly encoded.
    queryXml = queryXml.replace('<=', '&lt;-').replace('< ', '&lt; ');
    let query: any = this.x2jsTool.xml2js(queryXml);
    if (query && query.setSearchCriteria) {
      query.searchCriteria.searchCriteriaItem.forEach(i => {
        // this.setSearchCriteria(i);
      });
    }
  }

  public restore(queryData: IQueryData) {
    this.fillSearchCriteriaFromXML(queryData.searchCriteria);
    this.changeDetector.markForCheck();
  }

  public clear() {
    this.chemDrawWeb.setValue(null);
  }

  private retrieveAll() {
    this.router.navigate([`records/${this.temporary ? 'temp' : ''}`]);
  }

  private savePreference(e) {
  }

  private restorePreference(e) {
  }

  private cancel(e) {
    this.onClose.emit(e);
  }

  private togglePanel(e) {
    if (e.srcElement.children.length > 0) {
      e.srcElement.children[0].click();
    }
  }

  private onValueUpdated(e) {
    // console.log(this.searchItems);
  }
};
