import 'dart:async';

import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/models.dart';

abstract class AppRepositoryAbs {
  Future<List<Ubigeo>> getUbigeo(UserApp currentUser);
  Future<List<Bank>> getBanks(UserApp currentUser, String ubigeoId);
  Future<bool> saveBankAccount(UserApp currentUser, AccountFormData data);
  Future<List<BankAccount>> getBanksAccounts(UserApp currentUser);
  Stream<Rate> streamRate();
  Future<Coupon> validateCoupon(
      UserApp currentUser, String code, RequestType typeRequest, String amount);
  Future<ChangeRequest> fetchChangeRequestPending(UserApp currentUser);
  Future<ChangeRequest> requestChangePost(
      UserApp currentUser, RequestData formData);
  Future<bool> requestChangeDelete(UserApp currentUser, String requestId);
  Future<bool> requestChangePut(UserApp currentUser, String requestId,
      List<RequestPutData> requestPutData);
  Stream<ChangeRequest> streamChangeRequestStatus(String requestId);
  Future<List<History>> fetchHistory(UserApp currentUser);
  Future<ConfigRequest> fetchConfigRequest();
  Future<ChangeRequest> fetchHistoryDetail(
      UserApp currentUser, String requestId);
  Future<bool> putClientData(UserApp currentUser, ClientFormData formData);
  Stream<String> streamPreferentialRates(UserApp currentUser);
  Future<PreferentialRate> getPreferentialRate(UserApp currentUser);
  Future<bool> bankAccountEditAlias(
      UserApp currentUser, BankAccount bankAccount);
  Future<bool> deleteBankAccount(UserApp currentUser, String id);
}
