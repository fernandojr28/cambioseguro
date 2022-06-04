import 'dart:async';
import 'dart:convert';

import 'package:cambioseguro/abstract/app_repository_abs.dart';
import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/helpers/api_helpers.dart';
import 'package:cambioseguro/helpers/http_client.dart';
import 'package:cambioseguro/models/models.dart';
import 'package:cambioseguro/settings/settings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AppRepository extends AppRepositoryAbs {
  AppRepository(this.database);

  final FirebaseDatabase database;

  // @override
  // Future<Rate> getRates() async {

  //   http.Response response = await ApiHttpClient(http.Client())
  //       .get("${AppContants.endPoint}/config/rates");

  //   checkResponseSuccess(response);
  //   return Rate.fromJson(jsonDecode(response.body));
  // }

  @override
  Future<List<Ubigeo>> getUbigeo(UserApp currentUser) async {
    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .get("${AppContants.endPoint}/client/ubigeo");
    checkResponseSuccess(response);
    final Map res = jsonDecode(response.body);
    return (res['data'] as List).map((d) => Ubigeo.fromJson(d)).toList();
  }

  @override
  Future<List<Bank>> getBanks(UserApp currentUser, String ubigeoId) async {
    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .get("${AppContants.endPoint}/client/banks_ubigeo/$ubigeoId");
    checkResponseSuccess(response);
    final Map res = jsonDecode(response.body);
    return (res['data'] as List).map((d) => Bank.fromJson(d)).toList();
  }

  @override
  Future<bool> saveBankAccount(
      UserApp currentUser, AccountFormData data) async {
    String _body = jsonEncode(data.toJson());
    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .post("${AppContants.endPoint}/client/banks_accounts", body: _body);
    checkResponseSuccess(response);
    final res = jsonDecode(response.body);
    return res['error'] as bool;
  }

  @override
  Future<List<BankAccount>> getBanksAccounts(UserApp currentUser) async {
    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .get("${AppContants.endPoint}/client/banks_accounts");
    checkResponseSuccess(response);
    final Map res = jsonDecode(response.body);
    return (res['data']['bank_account'] as List)
        .map((d) => BankAccount.fromJson(d))
        .toList();
  }

  @override
  Stream<Rate> streamRate() {
    return database.reference().child('rates').onValue.map((Event onData) {
      if (onData.snapshot.value != null) {
        return Rate.fromJson(onData.snapshot.value);
      }
      return null;
    }).handleError((onError) {
      print(onError);
    });
  }

  @override
  Future<Coupon> validateCoupon(UserApp currentUser, String code,
      RequestType typeRequest, String amount) async {
    String _typeRequest = typeRequest.toString().split(".").last;
    String _body = jsonEncode({
      "code": "$code",
      "type_request": "$_typeRequest",
      "amount": "$amount"
    });
    http.Response response = await ApiHttpClient(http.Client(),
            token: currentUser.token)
        .post("${AppContants.endPoint}/client/validate_coupon", body: _body);
    checkResponseSuccess(response);
    final res = jsonDecode(response.body);
    if (res['error'])
      throw PlatformException(
          code: "${response.statusCode}",
          message: "${res['message'][0]}",
          details: response.body);

    return Coupon.fromJson(res['data']);
  }

  @override
  Future<ChangeRequest> fetchChangeRequestPending(UserApp currentUser) async {
    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .get("${AppContants.endPoint}/client/request/pending");
    checkResponseSuccess(response);
    final res = jsonDecode(response.body);
    if ((res['data'] as List).isNotEmpty) {
      final ChangeRequest req = ChangeRequest.fromJson(res['data'][0]);
      return req;
    }
    return null;
  }

  @override
  Future<ChangeRequest> requestChangePost(
      UserApp currentUser, RequestData formData) async {
    String _body = jsonEncode(formData.toMap);

    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .post("${AppContants.endPoint}/client/request", body: _body);

    final Map data = jsonDecode(response.body);
    // is slug refresh
    if (data['slug'] == "page-refresh") return ChangeRequest(pageRefresh: true);

    checkResponseSuccess(response);
    // final Map res = jsonDecode(response.body);
    return ChangeRequest.fromJson(data['data']);
  }

  @override
  Future<bool> requestChangeDelete(
      UserApp currentUser, String requestId) async {
    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .delete("${AppContants.endPoint}/client/request/$requestId");
    checkResponseSuccess(response);
    final res = jsonDecode(response.body);
    return res['error'] as bool;
  }

  @override
  Future<bool> requestChangePut(UserApp currentUser, String requestId,
      List<RequestPutData> requestPutData) async {
    String _body = jsonEncode({
      "codes_vouchers": requestPutData.map((c) => c.toJson()).toList(),
    });
    http.Response response = await ApiHttpClient(http.Client(),
            token: currentUser.token)
        .put("${AppContants.endPoint}/client/request/$requestId", body: _body);
    final Map data = jsonDecode(response.body);
    // is slug refresh
    if (data['slug'] == "page-refresh") return false;

    checkResponseSuccess(response);
    final res = jsonDecode(response.body);
    return res['error'] as bool;
  }

  @override
  Stream<ChangeRequest> streamChangeRequestStatus(String requestId) {
    return database.reference().child('client').child(requestId).onValue.map(
        (Event onData) => ChangeRequest.fromJsonStatus(onData.snapshot.value));
  }

  @override
  Future<List<History>> fetchHistory(UserApp currentUser) async {
    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .get("${AppContants.endPoint}/client/request");
    checkResponseSuccess(response);
    final res = jsonDecode(response.body);
    if ((res['data'] as List).isNotEmpty) {
      return (res['data'] as List).map((h) => History.fromJson(h)).toList();
    }
    return [];
  }

  @override
  Future<ConfigRequest> fetchConfigRequest() async {
    http.Response response = await ApiHttpClient(http.Client())
        .get("${AppContants.endPoint}/config/requests");
    checkResponseSuccess(response);
    final res = jsonDecode(response.body);
    return ConfigRequest.fomJson(res['data']);
  }

  @override
  Future<ChangeRequest> fetchHistoryDetail(
      UserApp currentUser, String requestId) async {
    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .get("${AppContants.endPoint}/client/request/$requestId");
    checkResponseSuccess(response);
    final res = jsonDecode(response.body);
    final ChangeRequest req = ChangeRequest.fromJson(res['data']);
    return req;
  }

  @override
  Future<bool> putClientData(
      UserApp currentUser, ClientFormData formData) async {
    String _body = jsonEncode(formData.toJson());
    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .put("${AppContants.endPoint}/client", body: _body);
    checkResponseSuccess(response);

    final Map res = jsonDecode(response.body);
    return res['error'] as bool;
  }

  @override
  Stream<String> streamPreferentialRates(UserApp currentUser) {
    return database
        .reference()
        .child('preferential_rates')
        .child("${currentUser.id}")
        .onValue
        .map((Event onData) {
      Map<dynamic, dynamic> data = onData.snapshot.value;
      if (onData.snapshot.value == null) return null;
      return data[data.keys.first]['_id'];
    });
  }

  @override
  Future<PreferentialRate> getPreferentialRate(UserApp currentUser) async {
    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .get("${AppContants.endPoint}/client/preferential_rate");

    checkResponseSuccess(response);
    final Map res = jsonDecode(response.body);
    if (res['data'] == null)
      throw PlatformException(
          code: '200', message: 'No found preferential rate', details: res);
    return PreferentialRate.fromJson(res['data']);
  }

  @override
  Future<bool> bankAccountEditAlias(
      UserApp currentUser, BankAccount bankAccount) async {
    String _body = jsonEncode({"alias": bankAccount.alias});
    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token).put(
            "${AppContants.endPoint}/client/banks_accounts/${bankAccount.id}",
            body: _body);
    checkResponseSuccess(response);
    final res = jsonDecode(response.body);
    return res['error'] as bool;
  }

  @override
  Future<bool> deleteBankAccount(UserApp currentUser, String id) async {
    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .delete("${AppContants.endPoint}/client/banks_accounts/$id");
    checkResponseSuccess(response);
    final res = jsonDecode(response.body);
    return res['error'] as bool;
  }
}
