import { Component, EventEmitter, Input, Output, OnChanges, ChangeDetectionStrategy, ViewEncapsulation } from '@angular/core';
import { NgRedux } from '@angular-redux/store';
import { IAppState } from '../../../redux';
import { RegBaseFormItem } from '../base-form-item';

@Component({
  selector: 'reg-drop-down-form-item-template',
  template: require('./drop-down-form-item.component.html'),
  encapsulation: ViewEncapsulation.None,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class RegDropDownFormItem extends RegBaseFormItem {
  protected dataSource: any[];
  protected valueExpr: string;
  protected displayExpr: string;
  protected useNumericValue: boolean = false;

  constructor(private ngRedux: NgRedux<IAppState>) {
    super();
  }

  deserializeValue(value: any): any {
    return this.useNumericValue ? +value : value;
  }

  serializeValue(value: any): any {
    return this.useNumericValue ? (value == null ? '' : value.toString()) : value;
  }

  protected update() {
    let options = this.viewModel.editorOptions;
    if (options.pickListDomain) {
      let pickListDomainIndex = options.pickListDomain as number;
      let lookups = this.ngRedux.getState().session.lookups;
      if (lookups && lookups.pickListDomains) {
        let pickListDomain = lookups.pickListDomains.find(d => d.ID === pickListDomainIndex);
        if (pickListDomain && pickListDomain.data) {
          let valueCol = 'value';
          this.dataSource = pickListDomain.data.map(d => {
            if (d[valueCol] === '') {
              d[valueCol] = ' ';
            }
            return d;
          });
          this.valueExpr = 'key';
          this.displayExpr = 'value';
        }
      }
    } else if (options.dropDownItemsSelect) {
      // TODO: Parse the select statement and use proper data for drop-down
    } else if (options.dataSource) {
      this.dataSource = options.dataSource;
      this.valueExpr = options.valueExpr;
      this.displayExpr = options.displayExpr;
      if (!this.value) {
        this.value = '';
      }
    }
    if (this.dataSource && this.dataSource.length > 0) {
      this.useNumericValue = typeof this.dataSource.slice(-1)[0][this.valueExpr] === 'number';
    }

    // set default value
    let isDefaultValueSet: boolean = false;
    if (!options.value) {
      if (this.editMode && options.defaultValue && options.defaultValue === '&&loggedInUser') {
        let lookups = this.ngRedux.getState().session.lookups;
        if (lookups) {
          let loggedInUserName = this.ngRedux.getState().session.user.fullName.toUpperCase();
          let user = lookups.users.find(user => user.USERID.toUpperCase() === loggedInUserName);
          options.value = user.PERSONID;
          isDefaultValueSet = true;
        }
      }
    }
    this.value = options && options.value ? this.deserializeValue(options.value) : undefined;

    // initialized default value, so update view model also
    if (isDefaultValueSet) {
      this.updateViewModel();
    }
  }
};
