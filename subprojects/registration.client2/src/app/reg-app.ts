import { Component, ViewEncapsulation } from '@angular/core';
import { AsyncPipe } from '@angular/common';
import { Observable } from 'rxjs/Observable';
import { DevToolsExtension, NgRedux, select } from 'ng2-redux';
import { NgReduxRouter } from 'ng2-redux-router';
import { createEpicMiddleware, combineEpics } from 'redux-observable';

import { IAppState, ISession, rootReducer } from '../store';
import { SessionActions } from '../actions/session.actions';
import { ConfigurationEpics, SessionEpics } from '../epics';
import { RegAboutPage, RegCounterPage } from '../pages';
import { middleware, enhancers, reimmutify } from '../store';

import {
  RegButton,
  RegNavigator,
  RegNavigatorHeader,
  RegNavigatorItems,
  RegNavigatorItem,
  RegLogo,
  RegLoginModal,
  RegFooter
} from '../components';

import { dev } from '../configuration';
import 'bootstrap/dist/js/bootstrap.min.js';

@Component({
  selector: 'reg-app',
  // Allow app to define global styles.
  encapsulation: ViewEncapsulation.None,
  styles: [
    require('../styles/index.css'),
    require('bootstrap/dist/css/bootstrap.min.css'),
    require('font-awesome/css/font-awesome.min.css'),
    require('devextreme/dist/css/dx.common.css'),
    require('devextreme/dist/css/dx.light.compact.css')
  ],
  template: require('./reg-app.html')
})
export class RegApp {
  @select(['session', 'hasError']) hasError$: Observable<boolean>;
  @select(['session', 'isLoading']) isLoading$: Observable<boolean>;
  @select(s => s.session.user.fullName) fullName$: Observable<string>;
  @select(s => !!s.session.token) loggedIn$: Observable<boolean>;
  @select(s => !s.session.token) loggedOut$: Observable<boolean>;

  constructor(
    private devTools: DevToolsExtension,
    private ngRedux: NgRedux<IAppState>,
    private ngReduxRouter: NgReduxRouter,
    private actions: SessionActions,
    private sessionEpics: SessionEpics,
    private configEpics: ConfigurationEpics) {

    middleware.push(createEpicMiddleware(combineEpics(
      sessionEpics.handleLoginUser,
      sessionEpics.handleLoginUserSuccess,
      configEpics.handleOpenTable
    )));

    ngRedux.configureStore(
      rootReducer,
      {},
      middleware,
      devTools.isEnabled() ?
        [...enhancers, devTools.enhancer()] :
        enhancers);

    ngReduxRouter.initialize();
  }
};
