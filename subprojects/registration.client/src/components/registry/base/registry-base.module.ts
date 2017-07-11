import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { RegDataGridFormItem } from './data-grid-form-item';
import { RegTagBoxFormItem } from './tag-box-form-item';
import { RegFormView } from './form-view';
import {
  DxCheckBoxModule,
  DxRadioGroupModule,
  DxDataGridModule,
  DxSelectBoxModule,
  DxNumberBoxModule,
  DxFormModule,
  DxPopupModule,
  DxLoadIndicatorModule,
  DxLoadPanelModule,
  DxScrollViewModule,
  DxTextAreaModule,
  DxListModule,
  DxTagBoxModule,
  DxTextBoxModule,
  DxValidatorModule
} from 'devextreme-angular';

export * from './data-grid-form-item';
export * from './tag-box-form-item';
export * from './form-view';

@NgModule({
  imports: [
    CommonModule,
    ReactiveFormsModule,
    RouterModule,
    DxCheckBoxModule,
    DxRadioGroupModule,
    DxDataGridModule,
    DxSelectBoxModule,
    DxNumberBoxModule,
    DxFormModule,
    DxPopupModule,
    DxLoadIndicatorModule,
    DxLoadPanelModule,
    DxScrollViewModule,
    DxTagBoxModule,
    DxTextAreaModule,
    DxListModule,
    DxTextBoxModule,
    DxValidatorModule
  ],
  declarations: [
    RegDataGridFormItem,
    RegTagBoxFormItem,
    RegFormView
  ],
  exports: [
    RegDataGridFormItem,
    RegTagBoxFormItem,
    RegFormView
  ]
})
export class RegBaseComponentModule { }