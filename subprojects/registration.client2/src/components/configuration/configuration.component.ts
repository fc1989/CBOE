import {
  Component,
  Input,
  Output,
  EventEmitter,
  ChangeDetectionStrategy,
} from '@angular/core';
import { ICounter } from '../../store';

@Component({
  selector: 'reg-configuration',
  template: `
    <div class="container">
      <h4 data-testid="configuration-heading" id="qa-configuration-heading">
        Configuration
      </h4>

      <dx-data-grid [columns]='gridColumns' [dataSource]='records' [paging]='{pageSize: 10}' 
        [pager]='{ showPageSizeSelector: true, allowedPageSizes: [5, 10, 20], showInfo: true }'
        [searchPanel]='{ visible: true }' [filterRow]='{ visible: true }' (onRowRemoving)='deleteRecord($event)'
        (onInitNewRow)='addRecord()' (onEditingStart)='editRecord($event)' rowAlternationEnabled=true,
        [editing]='{ mode: form, allowUpdating: true, allowDeleting: true, allowAdding: true }'>
      </dx-data-grid>
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class RegConfiguration {
  @Input() counter: ICounter;
  @Output() increment = new EventEmitter<void>();
  @Output() decrement = new EventEmitter<void>();
};
