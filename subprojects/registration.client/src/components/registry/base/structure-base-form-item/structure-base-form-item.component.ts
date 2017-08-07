import { Component, EventEmitter, Input, Output, ElementRef, OnChanges, ChangeDetectionStrategy, ViewEncapsulation } from '@angular/core';
import { IFormItemTemplate } from '../registry-base.types';
import { ChemDrawWeb } from '../../../common';

@Component({
  selector: 'reg-structure-base-form-item-template',
  template: ``,
  styles: [require('../registry-base.css')],
  encapsulation: ViewEncapsulation.None,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class RegStructureBaseFormItem extends ChemDrawWeb implements IFormItemTemplate {
  @Input() viewModel: any = {};
  @Input() viewConfig;
  @Output() valueUpdated: EventEmitter<any> = new EventEmitter<any>();

  constructor(elementRef: ElementRef) {
    super(elementRef);
  }

  deserializeValue(value: any): any {
    if (typeof value === 'object' && value.viewModel) {
      value = value.toString();
    }
    return value;
  }

  serializeValue(value: any): any  {
    return value;
  }

  protected update() {
    let options = this.viewModel.editorOptions;
    this.setValue(options && options.value ? this.deserializeValue(options.value) : null);
    super.update();
  }

  protected onContentChanged(e) {
    if (this.cdd && !this.cdd.isSaved()) {
      if (this.viewModel) {
        this.viewModel.component.option('formData.' + this.viewModel.dataField, this.serializeValue(this));
      }
      this.valueUpdated.emit(this);
    }
  }

  protected onValidatorInitialized(e, d) {
    e.component.peer = d;
  }

  protected validate(options) {
    return true;
  }
};
