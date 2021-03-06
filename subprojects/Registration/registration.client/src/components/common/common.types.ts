import { EventEmitter } from '@angular/core';
import { IValidationRuleData } from '../../redux';
import * as X2JS from 'x2js';

export interface IViewControl {
  activated: boolean;
  editMode: boolean;
  viewModel: any;
  viewConfig: any;
  valueUpdated: EventEmitter<any>;
}

export interface IFormItemTemplate extends IViewControl {
  deserializeValue(value: any): any;
  serializeValue(value: any): any;
}

export interface IParam {
  _name: string; // min
  _value: string; // 0
}

export class CParamList {
  param?: IParam[];
}

export interface IParamList extends CParamList {
}

export interface IValidationRule {
  _validationRuleName: string; // textLength
  _errorMessage: string; // The property value can have between 0 and 200 characters
  params?: IParamList;
}

export class CValidationRuleList {
  validationRule: IValidationRule[] = [];
}

export interface IValidationRuleList extends CValidationRuleList {
}

export interface IProperty {
  _name: string; // REG_COMMENTS
  _friendlyName?: string; // REG_COMMENTS
  _type?: string; // TEXT
  _precision?: string; // 200
  _sortOrder?: string; // 0
  _pickListDomainID?: string; // number
  _pickListDisplayValue?: string;
  validationRuleList?: IValidationRuleList;
  __text?: string;
}

export interface IPropertyList {
  Property: IProperty[];
}

export interface IRegNumber {
  RegID?: string; // 1826
  SequenceNumber?: string; // 877
  RegNumber?: string; // RN-000877
  SequenceID?: string; // 4
}

export interface IIdentifierID {
  _Description?: string;
  _Name?: string;
  _Active?: string; // T
  __text?: string; // 4
}

export interface IIdentifier {
  OrderIndex?: string; // 2621
  ID?: string;
  IdentifierID?: IIdentifierID;
  InputText?: string; // Dehydrohedione (DHH)
}

export class CIdentifierList {
  Identifier: IIdentifier[] = [];
}

export interface IIdentifierList extends CIdentifierList {
}

export interface IProjectID {
  _Description?: string; // Hedione Process Optimization
  _Name?: string; // Hedione Process Optimization
  _Active?: string; // T
  __text?: string; // 2
}

export interface IProject {
  ID?: string; // 381
  ProjectID?: IProjectID;
}

export class CProjectList {
  Project: IProject[] = [];
}

export interface IProjectList extends CProjectList {
}

export interface IChemicalStructure {
  _molWeight?: string; // 224.2961
  _formula?: string; // C13H20O3
  _update?: string; // yes
  __text?: string; // VmpD...
}

export class IStructureData {
  StructureID?: string; // 1821
  StructureFormat?: string;
  Structure?: IChemicalStructure;
  NormalizedStructure?: string; // VmpD...
  UseNormalization?: string; // F
  DrawingType?: any; // 0
  CanPropogateStructureEdits?: string; // True
  PropertyList?: IPropertyList;
  IdentifierList?: IIdentifierList;
  OrgDrawingType?: any;
}

export interface IBaseFragment {
  Structure: IStructureData;
}

export class CFragment {
  FragmentID?: string; // number
  ComponentFragmentID?: string;
  Code?: string;
  FragmentType?: string;
  Description?: string;
  Structure?: string;
  DateCreated?: string; // date
  DateLastModified?: string; // date
}

export interface IFragment extends CFragment {
}

export class CFragmentList {
  Fragment: IFragment[] = [new CFragment()];
}

export interface IFragmentList extends CFragmentList {
}

export class CCompound {
  CompoundID?: string; // 901
  DateCreated?: string; // 2017-01-15 08:21:51 pm
  PersonCreated?: string; // 61
  PersonApproved?: string; // 61
  PersonRegistered?: string; // 61
  DateLastModified?: string; // 2017-01-15 08:38:18 pm
  Tag?: string; // P1
  PropertyList?: IPropertyList;
  RegNumber?: IRegNumber;
  CanPropogateComponentEdits?: string; // True
  FragmentList: IFragmentList = new CFragmentList();
  IdentifierList?: IIdentifierList;
}

export interface ICompound extends CCompound {
}

export class CComponent {
  ID?: string;
  ComponentIndex?: string; // -901
  Compound: ICompound = new CCompound();
}

export interface IComponent extends CComponent {
}

export class CComponentList {
  Component: IComponent[] = [];
}

export interface IComponentList extends CComponentList {
}

export interface IBatchComponentFragment {
  ID?: string; // number
  FragmentID?: string; // number
  ComponentFragmentID?: string; // number
  Equivalents?: string; // number
  OrderIndex?: string; // number
}

export class CBatchComponentFragmentList {
  BatchComponentFragment: IBatchComponentFragment[] = [];
}

export interface IBatchComponentFragmentList extends CBatchComponentFragmentList {
}

export interface IBatchComponent {
  ID?: string; // 1721
  BatchID?: string; // 1741
  CompoundID?: string; // 901
  MixtureComponentID?: string; // 901
  ComponentIndex?: string; // -901
  ComponentRegNum?: string; // C000885
  PropertyList?: IPropertyList;
  BatchComponentFragmentList?: IBatchComponentFragmentList;
}

export class CBatchComponentList {
  BatchComponent: IBatchComponent[] = [];
}

export interface IBatchComponentList extends CBatchComponentList {
}

export interface IPerson {
  _displayName?: string; // PMORIEUX
  __text?: string; // 61
}

export class CBatch {
  BatchID?: string; // 1741
  BatchNumber?: string; // 1
  FullRegNumber?: string; // RN-000877-001
  DateCreated?: string; // 2017-01-15
  PersonCreated?: IPerson;
  PersonApproved?: IPerson;
  PersonRegistered?: IPerson;
  DateLastModified?: string; // 2017-01-15
  StatusID?: string; // 3
  IsBatchEditable?: string; // True
  ProjectList?: IProjectList;
  IdentifierList?: IIdentifierList;
  PropertyList?: IPropertyList;
  BatchComponentList?: IBatchComponentList;
}

export interface IBatch extends CBatch {
}

export class CBatchList {
  Batch: IBatch[] = [];
}

export interface IBatchList extends CBatchList {
}

export interface IEvent {
  _eventName?: string; // Inserting
  _eventHandler?: string; // OnInsertHandler
}

export interface IAddIn {
  _assembly?: string; // CambridgeSoft.COE.Registration.RegistrationAddins, Version=12.1.0.0, Culture=neutral, PublicKeyToken=f435ba95da9797dc
  _class?: string; // CambridgeSoft.COE.Registration.Services.RegistrationAddins.NormalizedStructureAddIn
  _friendlyName?: string; // Structure Normalization
  _required?: string; // no
  _enabled?: string; // no
  Event?: IEvent[];
  AddInConfiguration?: any;
  // <AddInConfiguration>
  //   <ScriptFile>C:\Program Files\CambridgeSoft\ChemOfficeEnterprise12.1.0.0\Registration\PythonScripts\parentscript.py</ScriptFile>
  //   <!--Commented <PythonWebServiceURL> to bypass soap
  // <PythonWebServiceURL>http://localhost/PyEngine/Service.asmx</PythonWebServiceURL> -->
  //   <StructuresIdsToAvoid>-2|-3|</StructuresIdsToAvoid>
  // </AddInConfiguration>
}

export class CAddInList {
  AddIn: IAddIn[] = [];
}

export interface IAddInList extends CAddInList {
}

export class CValidator {
  private static getParamNumber(params: IParam[], name: string, defaultValue: number = undefined): number {
    let param = params.find(p => p._name === name);
    return param != null ? +param._value : defaultValue;
  }

  private static validateRequiredField(rule: IValidationRule, e) {
    if (!e.value || (e.value.length && e.value.length === 0)) {
      e.rule.isValid = false;
    }
  }

  private static validateTextLength(rule: IValidationRule, e) {
    if (e.value && typeof e.value === 'string') {
      let min = this.getParamNumber(rule.params.param, 'min', 0);
      let max = this.getParamNumber(rule.params.param, 'max');
      if (max) {
        let length = e.value.length;
        e.rule.isValid = length >= min && length <= max;
      }
    }
  }

  private static filterFloat(value): number {
    if (/^(\-|\+)?([0-9]+(\.[0-9]+)?)$/.test(value)) {
      return Number(value);
    }
    return NaN;
  }

  private static validateInteger(rule: IValidationRule, e) {
    if (e.value) {
      let IntegerValue = Number(e.value);
      if (isNaN(IntegerValue) || (IntegerValue % 1 !== 0)) {
        e.rule.isValid = false;
      }
    }
  }

  private static validateFloat(rule: IValidationRule, e) {
    if (e.value) {
      let floatingValue = this.filterFloat(e.value);
      if (isNaN(floatingValue)) {
        e.rule.isValid = false;
      } else {
        if (floatingValue < 0) {
          floatingValue = Math.abs(floatingValue);
        }
        const integerPart = this.getParamNumber(rule.params.param, 'integerPart');
        const decimalPart = this.getParamNumber(rule.params.param, 'decimalPart');
        const valueIntegerPart = floatingValue === 0 ? 0 : Math.ceil(Math.log10(floatingValue));
        if (integerPart && valueIntegerPart > integerPart) {
          e.rule.isValid = false;
        } else if (decimalPart) {
          const v: string = e.value;
          const i = v.indexOf('.');
          const valueDecimalPart = i > 0 ? v.length - i - 1 : 0;
          e.rule.isValid = valueDecimalPart <= decimalPart;
        } else {
          // Integer part rule is missing or validated, or
          // Decimal part rule is missing.
          // Therefore it is validated.
          e.rule.isValid = true;
        }
      }
    }
  }

  private static validateNumericRange(rule: IValidationRule, e) {
    if (e.value) {
      let min = this.getParamNumber(rule.params.param, 'min');
      let max = this.getParamNumber(rule.params.param, 'max');
      if (min != null && max != null) {
        let floatingValue = Number(e.value);
        if (isNaN(floatingValue)) {
          e.rule.isValid = false;
        } else {
          e.rule.isValid = (floatingValue >= min) && (floatingValue <= max);
        }
      }
    }
  }

  private static validateWordList(rule: IValidationRule, e) {
    if (e.value) {
      e.rule.isValid = rule.params.param.find(p => p._name === 'validWord' && p._value === e.value) != null;
    }
  }

  private static validateCas(rule: IValidationRule, e) {
    e.rule.isValid = true;
    if (e.value) {
      let isValid = /^[0-9]{1,7}-[0-9][0-9]-[0-9]$/.test(e.value);
      if (isValid) {
        const freeCas = e.value.replace(/-/g, '');
        let casSum = 0;
        for (let casIndex = freeCas.length - 1; casIndex > 0; --casIndex) {
          casSum += casIndex * (freeCas.substring(freeCas.length - casIndex - 1, freeCas.length - casIndex));
        }
        isValid = (casSum % 10) === ((freeCas.substring(freeCas.length - 1, freeCas.length)) % 10);
      }
      e.rule.isValid = isValid;
    }
  }

  private static checkRequiredFieldsForDropDown(dxForm, script: string, e): boolean {
    const value = e.value;
    if (script.indexOf('DropDown_CheckRequiredFields') > 0) {
      const m = script.match(/DropDown_CheckRequiredFields[^,]*,[^,]*,[^,]*,\s*'([^']*)'[^,]*,\s*'([^']*)'/);
      if (m && m.length === 3) {
        if (value) {
          return !!dxForm.option('formData.' + m[1].trim());
        } else {
          const requiredValue = dxForm.option('formData.' + m[1].trim());
          if (requiredValue) {
            e.rule.message = 'Required!';
            return false;
          }
        }
      }
    }
    return true;
  }

  private static checkRequiredFieldsForCheckBox(dxForm, script: string, e): boolean {
    const value = e.value;
    if (value && script.indexOf('CheckBox_CheckRequiredFields') > 0) {
      const m = script.match(/CheckBox_CheckRequiredFields[^,]*,[^,]*,[^,]*,\s*'([^']*)'[^,]*,\s*'([^']*)'/);
      if (m && m.length === 3) {
        return !!dxForm.option('formData.' + m[1].trim());
      }
    }
    return true;
  }

  private static validateCustom(dxForm, rule: IValidationRule, e) {
    if (rule.params && rule.params.param) {
      const clientScript = rule.params.param.find(p => p._name === 'clientscript');
      if (clientScript != null) {
        const script = clientScript._value;
        if (script) {
          e.rule.isValid = this.checkRequiredFieldsForDropDown(dxForm, script, e) && this.checkRequiredFieldsForCheckBox(dxForm, script, e);
        }
      }
    }
  }

  public static validate(e) {
    e.rule.isValid = true;
    e.rule.message = undefined;
    const peer: IFormItemTemplate = e.validator.peer;
    const ruleList: IValidationRuleList = peer.viewModel.editorOptions.customRules;
    if (ruleList && ruleList.validationRule) {
      ruleList.validationRule.forEach(r => {
        if (e.rule.isValid) {
          if (r._validationRuleName === 'requiredField') {
            this.validateRequiredField(r, e);
          } else if (r._validationRuleName === 'textLength') {
            this.validateTextLength(r, e);
          } else if (r._validationRuleName === 'integer') {
            this.validateInteger(r, e);
          } else if (r._validationRuleName === 'float') {
            this.validateFloat(r, e);
          } else if (r._validationRuleName === 'numericRange') {
            this.validateNumericRange(r, e);
          } else if (r._validationRuleName === 'wordListEnumeration') {
            this.validateWordList(r, e);
          } else if (r._validationRuleName === 'casValidation') {
            this.validateCas(r, e);
          } else if (r._validationRuleName === 'custom') {
            this.validateCustom(peer.viewModel.component, r, e);
          } else {
            // console.log(r);
          }
          if (!e.rule.isValid && !e.rule.message) {
            if (r._errorMessage) {
              e.rule.message = r._errorMessage;
            } else {
              e.rule.message = 'Invalid entry!';
            }
          }
        }
      });
    }
    return e.rule.isValid;
  }

  public static getValidationRules(ruleDataList: IValidationRuleData[]): any[] {
    let rules = [];
    if (ruleDataList) {
      ruleDataList.forEach(rd => {
        let rule: any = {};
        if (rd.name === 'requiredField' || rd.name === 'chemicallyValid') {
          rule.type = 'required';
        } else if (rd.name === 'textLength') {
          rule.type = 'stringLength';
          rule.min = rd.min ? +rd.min : this.getParamNumber(rd.parameters, 'min', 0);
          rule.max = rd.max ? +rd.max : this.getParamNumber(rd.parameters, 'min', 100);
        } else if (rd.name === 'float') {
          // TODO
        } else if (rd.name === 'numericRange') {
          // TODO
        } else if (rd.name === 'wordListEnumeration') {
          // TODO
        } else if (rd.name === 'positiveNumber') {
          rule.type = 'custom';
          rule.validationCallback = (options): boolean => {
            const value = options.value;
            const numericValue = Number(value);
            return !isNaN(numericValue) && numericValue > 0;
          };
        } else {
          // console.log(r);
        }
        if (rule.type != null) {
          if (rd.error != null) {
            rule.message = rd.error;
          }
          rules.push(rule);
        }
      });
    }
    return rules;
  }
}
