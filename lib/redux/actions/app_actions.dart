import 'dart:async';

import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
export 'auth_actions.dart';

class InitAppAction {
  UserApp user;

  InitAppAction(UserApp _user) {
    this.user = _user == null ? UserApp(token: "") : _user;
  }
}

class ErrorExceptionResponseAction {
  final dynamic error;
  ErrorExceptionResponseAction(this.error);
}

class LoadUbigeoRequestAction {}

class LoadUbigeoResponseAction {
  final List<Ubigeo> ubigeos;

  LoadUbigeoResponseAction(this.ubigeos);
}

class LoadBanksRequestAction {
  final String ubigeoId;
  final VoidCallback onCompeleted;
  final ErrorCallback onError;
  LoadBanksRequestAction(this.ubigeoId, this.onCompeleted, this.onError);
}

class LoadBanksResponseAction {
  final List<Bank> banks;

  LoadBanksResponseAction(this.banks);
}

class SaveBankAccountRequestAction {
  final AccountFormData data;
  final VoidCallback onCompeleted;
  final ErrorCallback onError;
  SaveBankAccountRequestAction({this.data, this.onCompeleted, this.onError});
}

class SaveBankAccountResponseAction {
  final String message;
  final bool error;
  final dynamic data;

  SaveBankAccountResponseAction(this.error, {this.message, this.data});
}

class LoadBanksAccountsRequestAction {}

class LoadBanksAccountsResponseAction {
  final List<BankAccount> bankAccounts;

  LoadBanksAccountsResponseAction(this.bankAccounts);
}

class EditBankAccountRequestAction {
  final BankAccount bankAccount;
  final VoidCallback onCompeleted;
  final ErrorCallback onError;

  EditBankAccountRequestAction(
      {this.bankAccount, this.onCompeleted, this.onError});
}

class DeleteBankAccountRequestAction {
  final String id;
  final VoidCallback onCompeleted;
  final ErrorCallback onError;

  DeleteBankAccountRequestAction(this.id, this.onCompeleted, this.onError);
}

class LoadRateResponseAction {
  final Rate rate;

  LoadRateResponseAction(this.rate);
}

class RequestChangeAction {
  final RequestData data;
  final VoidCallback onCompeleted;
  final dynamic onError;

  RequestChangeAction(this.data, this.onCompeleted, this.onError);
}

class RequestChangePendingRequestAction {
  final VoidCallback onCompeleted;
  final ErrorCallback onError;

  RequestChangePendingRequestAction({this.onCompeleted, this.onError});
}

class RequestChangeResponseAction {
  final ChangeRequest request;

  RequestChangeResponseAction(this.request);
}

class RequestChangeSubscribeAction {
  final String requestId;

  RequestChangeSubscribeAction(this.requestId);
}

class RequestChangeStreamAction {
  final ChangeRequest request;

  RequestChangeStreamAction(this.request);
}

class RequestChangeDeleteRequestAction {}

class RequestChangeDeleteResponseAction {}

class RequestChangePutRequestAction {
  final List<RequestPutData> data;
  final VoidCallback onCompeleted;
  final ErrorCallback onError;

  RequestChangePutRequestAction(this.data, this.onCompeleted, this.onError);
}

class RequestCouponValidateAction {
  final String code;
  final RequestType typeRequest;
  final String amount;
  final VoidCallback onSuccess;
  final ErrorCallback onError;

  RequestCouponValidateAction(
      {this.code, this.typeRequest, this.amount, this.onSuccess, this.onError});
}

class RequestCouponValidateResponse {
  final Coupon coupon;

  RequestCouponValidateResponse(this.coupon);
}

class DeleteCouponRequestAction {}

class FetchHistorysRequest {}

class FetchHistoryResponse {
  final List<History> requests;

  FetchHistoryResponse(this.requests);
}

class LoadconfigRequestAction {}

class LoadconfigResponseAction {
  final ConfigRequest config;

  LoadconfigResponseAction(this.config);
}

class LoadHistoryRequestAction {
  final String historyId;
  LoadHistoryRequestAction(this.historyId);
}

class LoadHistoryResponseAction {
  final ChangeRequest request;

  LoadHistoryResponseAction(this.request);
}

class NavigateToHomeScreen {}

class ClientDataPostAction {
  final ClientFormData formData;
  final VoidCallback onCompeleted;
  final ErrorCallback onError;

  ClientDataPostAction({this.formData, this.onCompeleted, this.onError});
}

class ClientPreferentialRateRequestAction {}

class CleanferentialRateResponseAction {}

class ClientPreferentialRateResponseAction {
  final PreferentialRate preferentialRate;

  ClientPreferentialRateResponseAction(this.preferentialRate);
}

class ClientPreferentialRateDeleteRequestAction {}

class PullRefreshRequestAction {
  final Completer completer;

  PullRefreshRequestAction({Completer completer})
      : this.completer = completer ?? new Completer();
}
