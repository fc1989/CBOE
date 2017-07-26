import { Component, EventEmitter, Input, Output, OnChanges, ChangeDetectionStrategy, ViewEncapsulation } from '@angular/core';
import { IViewControl, IIdentifierList, CIdentifierList } from '../registry-base.types';
import { RegDataGridFormItem } from '../data-grid-form-item';
import { NgRedux } from '@angular-redux/store';
import { IAppState } from '../../../../redux';

@Component({
  selector: 'reg-id-list-form-item-template',
  template: require('../data-grid-form-item/data-grid-form-item.component.html'),
  encapsulation: ViewEncapsulation.None,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class RegIdListFormItem extends RegDataGridFormItem {
  constructor(private ngRedux: NgRedux<IAppState>) {
    super();
  }

  private deserializeValue(value: IIdentifierList) {
    return value.Identifier ? value.Identifier.map(i => {
      return { id: +i.IdentifierID.__text, inputText: i.InputText };
    }) : [];
  }

  private serializeValue(): IIdentifierList {
    let value = this.dataSource;
    return value && value.length > 0 ? { Identifier: value.map(v => {
      return {
        IdentifierID: { __text: v.id },
        InputText: v.inputText
      };
    })} : undefined;
  }

  protected update() {
    let lookups = this.ngRedux.getState().session.lookups;
    let options = this.viewModel.editorOptions;
    let value = options && options.value ? options.value : [];
    this.dataSource = this.deserializeValue(value);
    this.columns = lookups ? [{
      dataField: 'id',
      caption: 'Identifier',
      editorType: 'dxSelectBox',
      lookup: {
        dataSource: lookups.identifierTypes.filter(i => i.TYPE === options.idListType && i.ACTIVE === 'T'),
        displayExpr: 'NAME',
        valueExpr: 'ID',
        placeholder: 'Select Identifier'
      }
    }, {
      dataField: 'inputText',
      caption: 'Value'
    }] : [];
    if (this.editMode && this.columns.length > 0 && !this.columns[0].headerCellTemplate) {
      this.columns.unshift({
        cellTemplate: 'commandCellTemplate',
        headerCellTemplate: 'commandHeaderCellTemplate',
        width: 80
      });
    } else if (!this.editMode && this.columns.length > 0 && this.columns[0].headerCellTemplate) {
      this.columns.splice(0, 1);
    }
    this.editingMode = 'row';
    this.allowUpdating = true;
    this.allowDeleting = true;
    this.allowAdding = true;
  }

  protected onRowInserted(e, d) {
    this.onValueChanged(d.component);
  }

  protected onRowUpdated(e, d) {
    this.onValueChanged(d.component);
  }

  protected onRowRemoved(e, d) {
    this.onValueChanged(d.component);
  }

  protected onValueChanged(component) {
    let value = this.serializeValue();
    component.option(`formData.${this.viewModel.editorOptions.dataField}`, value);
    this.onValueUpdated(this);    
  }
};