import { Component, Inject, ApplicationRef } from '@angular/core';
import { ConfigurationActions } from '../actions';
import { RegContainer, RegConfiguration } from '../components';
import { IConfiguration } from '../store/configuration';

@Component({
  selector: 'configuration-page',
  providers: [ ConfigurationActions ],
  template: `
    <reg-container testid="configuration">
      <reg-configuration>
      </reg-configuration>
    </reg-container>
  `
})
export class RegConfigurationPage {
  constructor() {}
}
