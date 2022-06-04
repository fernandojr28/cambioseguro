import 'package:cambioseguro/abstract/app_repository_abs.dart';
import 'package:cambioseguro/models/models.dart';
import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAppMiddleware(
  AppRepositoryAbs appRepository,
) {
  return [
    TypedMiddleware<AppState, LogInSuccessfulResponseAction>(
        _createUbigeoMiddleware(appRepository)),
    TypedMiddleware<AppState, LogInSuccessfulResponseAction>(
        _loadConfigRequest(appRepository)),
    TypedMiddleware<AppState, LoadBanksRequestAction>(
        _loadBankByUbigeoMiddleware(appRepository)),
    TypedMiddleware<AppState, SaveBankAccountRequestAction>(
        _saveBankBAccountMiddleware(appRepository)),
    TypedMiddleware<AppState, LoadBanksAccountsRequestAction>(
        _fetchBankAccountsMiddleware(appRepository)),
    TypedMiddleware<AppState, LogInSuccessfulResponseAction>(
        _fetchRateMiddleware(appRepository)),
    TypedMiddleware<AppState, RequestCouponValidateAction>(
        _validateCoupon(appRepository)),
    TypedMiddleware<AppState, RequestChangeAction>(
        _requestChange(appRepository)),
    TypedMiddleware<AppState, RequestChangeDeleteRequestAction>(
        _requestDelete(appRepository)),
    TypedMiddleware<AppState, LogInSuccessfulResponseAction>(
        _fetchChangeRequest(appRepository)),
    TypedMiddleware<AppState, RequestChangePendingRequestAction>(
        _fetchChangeRequest(appRepository)),
    TypedMiddleware<AppState, RequestChangePutRequestAction>(
        _putChangeRequest(appRepository)),
    TypedMiddleware<AppState, RequestChangeSubscribeAction>(
        _streamChangeRequestStatus(appRepository)),
    TypedMiddleware<AppState, FetchHistorysRequest>(
        _fetchHistorys(appRepository)),
    TypedMiddleware<AppState, LoadHistoryRequestAction>(
        _fetchHistoryDetail(appRepository)),
    TypedMiddleware<AppState, ClientDataPostAction>(
        _putClientData(appRepository)),
    TypedMiddleware<AppState, LogInSuccessfulResponseAction>(
        _streamPreferentialRate(appRepository)),
    TypedMiddleware<AppState, ClientPreferentialRateRequestAction>(
        _getPreferentialRate(appRepository)),
    TypedMiddleware<AppState, EditBankAccountRequestAction>(
        _updateBankBAccountMiddleware(appRepository)),
    TypedMiddleware<AppState, DeleteBankAccountRequestAction>(
        _deleteBankAccount(appRepository)),

    // loaders
  ];
}

void Function(
  Store<AppState> store,
  LogInSuccessfulResponseAction action,
  NextDispatcher next,
) _createUbigeoMiddleware(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository.getUbigeo(store.state.currentUser).then((data) {
      store.dispatch(LoadUbigeoResponseAction(data));
    }).catchError((onError) {
      store.dispatch(ErrorExceptionResponseAction(onError));
    });
  };
}

void Function(
  Store<AppState> store,
  LoadBanksRequestAction action,
  NextDispatcher next,
) _loadBankByUbigeoMiddleware(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository
        .getBanks(store.state.currentUser, action.ubigeoId)
        .then((data) {
      store.dispatch(LoadBanksResponseAction(data));
      action.onCompeleted();
    }).catchError((onError) {
      store.dispatch(ErrorExceptionResponseAction(onError));
      action.onError(onError);
    });
  };
}

void Function(
  Store<AppState> store,
  SaveBankAccountRequestAction action,
  NextDispatcher next,
) _saveBankBAccountMiddleware(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    // next(action);
    appRepository
        .saveBankAccount(store.state.currentUser, action.data)
        .then((isError) {
      store.dispatch(SaveBankAccountResponseAction(isError));
      action.onCompeleted();
    }).catchError((onError) {
      // store.dispatch(ErrorExceptionResponseAction(onError));
      action.onError(onError);
    });
  };
}

void Function(
  Store<AppState> store,
  EditBankAccountRequestAction action,
  NextDispatcher next,
) _updateBankBAccountMiddleware(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    // next(action);
    appRepository
        .bankAccountEditAlias(store.state.currentUser, action.bankAccount)
        .then((isError) {
      store.dispatch(LoadBanksAccountsRequestAction());
      action.onCompeleted();
    }).catchError((onError) {
      // store.dispatch(ErrorExceptionResponseAction(onError));
      action.onError(onError);
    });
  };
}

void Function(
  Store<AppState> store,
  LoadBanksAccountsRequestAction action,
  NextDispatcher next,
) _fetchBankAccountsMiddleware(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository.getBanksAccounts(store.state.currentUser).then((data) {
      store.dispatch(LoadBanksAccountsResponseAction(data));
    }).catchError((onError) {
      store.dispatch(ErrorExceptionResponseAction(onError));
    });
  };
}

void Function(
  Store<AppState> store,
  LogInSuccessfulResponseAction action,
  NextDispatcher next,
) _fetchRateMiddleware(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository.streamRate().listen((data) {
      store.dispatch(LoadRateResponseAction(data));
    }).onError((onError) {
      print(onError);
      store.dispatch(ErrorExceptionResponseAction(onError));
    });
  };
}

void Function(
  Store<AppState> store,
  RequestCouponValidateAction action,
  NextDispatcher next,
) _validateCoupon(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository
        .validateCoupon(store.state.currentUser, action.code,
            action.typeRequest, action.amount)
        .then((data) {
      store.dispatch(RequestCouponValidateResponse(data));
      action.onSuccess();
    }).catchError((onError) {
      store.dispatch(ErrorExceptionResponseAction(onError));
      action.onError(onError);
    });
  };
}

void Function(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) _fetchChangeRequest(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository
        .fetchChangeRequestPending(store.state.currentUser)
        .then((data) {
      store.dispatch(RequestChangeResponseAction(data));
      //subscription
      if (data != null) store.dispatch(RequestChangeSubscribeAction(data.id));
      if (action.onCompeleted != null) action.onCompeleted();
    }).catchError((onError) {
      // action.onError(onError);
      // debugPrint(onError);
      if (action.onError != null) action.onError(onError);
    });
  };
}

void Function(
  Store<AppState> store,
  RequestChangeAction action,
  NextDispatcher next,
) _requestChange(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository
        .requestChangePost(store.state.currentUser, store.state.requestData)
        .then((data) {
      if (data.pageRefresh) store.dispatch(RequestChangePendingRequestAction());

      store.dispatch(RequestChangePendingRequestAction(
        onCompeleted: action.onCompeleted,
        onError: action.onError,
      ));
      // store.dispatch(RequestChangeResponseAction(data));
      // action.onCompeleted();
    }).catchError((onError) {
      action.onError(onError);
    });
  };
}

void Function(
  Store<AppState> store,
  RequestChangeDeleteRequestAction action,
  NextDispatcher next,
) _requestDelete(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    appRepository
        .requestChangeDelete(
            store.state.currentUser, store.state.changeRequest.id)
        .then((data) {
      // clean data
      store.dispatch(CleanferentialRateResponseAction());
      store.dispatch(DeleteCouponRequestAction());
      store.dispatch(RequestChangeDeleteResponseAction());
    }).catchError((onError) {
      store.dispatch(ErrorExceptionResponseAction(onError));
    }).whenComplete(() {
      next(action);
    });
  };
}

void Function(
  Store<AppState> store,
  RequestChangePutRequestAction action,
  NextDispatcher next,
) _putChangeRequest(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository
        .requestChangePut(
            store.state.currentUser, store.state.changeRequest.id, action.data)
        .then((bool isSuccess) {
      if (isSuccess)
        store.dispatch(
            RequestChangeSubscribeAction(store.state.changeRequest.id));
      else
        store.dispatch(LogInSuccessfulResponseAction(store.state.currentUser));

      action.onCompeleted();
    }).catchError((onError) {
      if (onError is PlatformException) action.onError(onError);
    });
  };
}

void Function(
  Store<AppState> store,
  RequestChangeSubscribeAction action,
  NextDispatcher next,
) _streamChangeRequestStatus(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository.streamChangeRequestStatus(action.requestId).listen((data) {
      store.dispatch(RequestChangeStreamAction(data));
    }).onError((onError) {
      store.dispatch(ErrorExceptionResponseAction(onError));
    });
  };
}

void Function(
  Store<AppState> store,
  FetchHistorysRequest action,
  NextDispatcher next,
) _fetchHistorys(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository.fetchHistory(store.state.currentUser).then((data) {
      store.dispatch(FetchHistoryResponse(data));
    }).catchError((onError) {
      store.dispatch(ErrorExceptionResponseAction(onError));
    });
  };
}

void Function(
  Store<AppState> store,
  LogInSuccessfulResponseAction action,
  NextDispatcher next,
) _loadConfigRequest(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository.fetchConfigRequest().then((data) {
      store.dispatch(LoadconfigResponseAction(data));
    }).catchError((onError) {
      store.dispatch(ErrorExceptionResponseAction(onError));
    });
  };
}

void Function(
  Store<AppState> store,
  LoadHistoryRequestAction action,
  NextDispatcher next,
) _fetchHistoryDetail(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository
        .fetchHistoryDetail(store.state.currentUser, action.historyId)
        .then((data) {
      store.dispatch(LoadHistoryResponseAction(data));
    }).catchError((onError) {
      store.dispatch(ErrorExceptionResponseAction(onError));
    });
  };
}

void Function(
  Store<AppState> store,
  ClientDataPostAction action,
  NextDispatcher next,
) _putClientData(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    appRepository
        .putClientData(store.state.currentUser, action.formData)
        .then((bool isError) {
      // dispatch update data
      store.dispatch(UpdateUSerDataRequestAction(store.state.currentUser));
      action.onCompeleted();
    }).catchError((onError) {
      store.dispatch(ErrorExceptionResponseAction(onError));
      action.onError(onError);
    }).whenComplete(() {
      next(action);
    });
  };
}

void Function(
  Store<AppState> store,
  LogInSuccessfulResponseAction action,
  NextDispatcher next,
) _streamPreferentialRate(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository
        .streamPreferentialRates(store.state.currentUser)
        .listen((data) {
      if (data == null)
        store.dispatch(CleanferentialRateResponseAction());
      else
        store.dispatch(ClientPreferentialRateRequestAction());
    }).onError((onError) {
      // store.dispatch(ErrorExceptionResponseAction(onError));
    });
  };
}

void Function(
  Store<AppState> store,
  ClientPreferentialRateRequestAction action,
  NextDispatcher next,
) _getPreferentialRate(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository.getPreferentialRate(store.state.currentUser).then((data) {
      store.dispatch(ClientPreferentialRateResponseAction(data));
    }).catchError((onError) {
      store.dispatch(ErrorExceptionResponseAction(onError));
    });
  };
}

void Function(
  Store<AppState> store,
  DeleteBankAccountRequestAction action,
  NextDispatcher next,
) _deleteBankAccount(AppRepositoryAbs appRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    appRepository
        .deleteBankAccount(store.state.currentUser, action.id)
        .then((data) {
      store.dispatch(LoadBanksAccountsRequestAction());
      action.onCompeleted();
    }).catchError((onError) {
      // store.dispatch(ErrorExceptionResponseAction(onError));
      action.onError(onError);
    });
  };
}
