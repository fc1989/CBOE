import { Injectable } from '@angular/core';
import { NgRedux } from '@angular-redux/store';
import { Http } from '@angular/http';
import { UPDATE_LOCATION } from '@angular-redux/router';
import { IPayloadAction, RegistrySearchActions, RegistryActions, SessionActions, IGridPullAction } from '../actions';
import { Action, MiddlewareAPI } from 'redux';
import { createAction } from 'redux-actions';
import { Epic, ActionsObservable, combineEpics } from 'redux-observable';
import { IAppState, IHitlistData, IHitlistRetrieveInfo } from '../store';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/observable/of';
import 'rxjs/add/operator/mergeMap';
import 'rxjs/add/operator/filter';
import 'rxjs/add/operator/catch';
import { apiUrlPrefix } from '../configuration';
import { notify, notifySuccess } from '../common';

@Injectable()
export class RegistrySearchEpics {
  constructor(private http: Http, private ngRedux: NgRedux<IAppState>) { }

  handleRegistrySearchActions: Epic = (action$: ActionsObservable, store: MiddlewareAPI<any>) => {
    return combineEpics(
      this.handleOpenHitlists,
      this.handleDeleteHitlist,
      this.handleUpdateHitlist,
      this.handleRetrieveHitlist,
      this.handleSearchRecords
    )(action$, store);
  }

  private handleOpenHitlists: Epic = (action$: Observable<ReduxActions.Action<any>>) => {
    return action$.filter(({ type }) => type === RegistrySearchActions.OPEN_HITLISTS)
      .mergeMap(() => {
        return this.http.get(`${apiUrlPrefix}hitlists`)
          .map(result => {
            return result.url.indexOf('index.html') > 0
              ? SessionActions.logoutUserAction()
              : RegistrySearchActions.openHitlistsSuccessAction(result.json());
          })
          .catch(error => Observable.of(RegistrySearchActions.openHitlistsErrorAction(error)));
      });
  }

  private handleDeleteHitlist: Epic = (action$: Observable<ReduxActions.Action<{ id: number }>>) => {
    return action$.filter(({ type }) => type === RegistrySearchActions.DELETE_HITLIST)
      .mergeMap(({ payload }) => {
        return this.http.delete(`${apiUrlPrefix}hitlists/${payload.id}`)
          .map(result => {
            if (result.url.indexOf('index.html') > 0) {
              SessionActions.logoutUserAction();
            } else {
              notifySuccess('The selected hitlist was deleted successfully!', 5000);
              return RegistrySearchActions.openHitlistsAction();
            }
          })
          .catch(error => Observable.of(RegistrySearchActions.deleteHitlistErrorAction(error)));
      });
  }

  handleUpdateHitlist = (action$: Observable<ReduxActions.Action<IHitlistData>>) => {
    return action$.filter(({ type }) => type === RegistrySearchActions.UPDATE_HITLIST)
      .mergeMap(({ payload }) => {
        return this.http.put(`${apiUrlPrefix}hitlists/${payload.hitlistId}`, payload)
          .map(result => {
            notifySuccess('The selected hitlist was updated successfully!', 5000);
            return RegistrySearchActions.openHitlistsAction();
          })
          .catch(error => Observable.of(RegistrySearchActions.updateHitlistErrorAction()));
      });
  }

  private handleRetrieveHitlist: Epic = (action$: Observable<ReduxActions.Action<IHitlistRetrieveInfo>>) => {
    return action$.filter(({ type }) => type === RegistrySearchActions.RETRIEVE_HITLIST)
      .mergeMap(({ payload }) => {
        if (payload.type === 'Retrieve' || payload.type === 'Refresh') {
          return this.http.get(`${apiUrlPrefix}hitlists/${payload.id}/records${payload.type === 'Refresh' ? '?refresh=true' : ''}`)
            .map(result => {
              return result.url.indexOf('index.html') > 0
                ? SessionActions.logoutUserAction()
                : RegistryActions.openRecordsSuccessAction(payload.temporary, result.json());
            })
            .catch(error => Observable.of(RegistrySearchActions.retrieveHitlistErrorAction(error)));
        } else if (payload.type === 'Advanced') {
          return this.http.get(`${apiUrlPrefix}hitlists/${payload.data.id1}/${payload.data.op}/${payload.data.id2}/records`)
            .map(result => {
              return result.url.indexOf('index.html') > 0
                ? SessionActions.logoutUserAction()
                : RegistryActions.openRecordsSuccessAction(payload.temporary, result.json());
            })
            .catch(error => Observable.of(RegistrySearchActions.retrieveHitlistErrorAction(error)));
        }
      });
  }

  private handleSearchRecords: Epic = (action$: Observable<ReduxActions.Action<{ temporary: boolean, searchCriteria: string}>>) => {
    return action$.filter(({ type }) => type === RegistrySearchActions.SEARCH_RECORDS)
      .mergeMap(({ payload }) => {
        return this.http.post(`${apiUrlPrefix}search/records`, payload)
          .map(result => {
            return result.url.indexOf('index.html') > 0
              ? SessionActions.logoutUserAction()
              : RegistryActions.openRecordsSuccessAction(payload.temporary, result.json());
          })
          .catch(error => Observable.of(RegistrySearchActions.searchRecordsErrorAction(error)));
      });
  }
}
