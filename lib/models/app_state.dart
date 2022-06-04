import 'package:cambioseguro/models/models.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final bool isLoading;
  final UserApp currentUser;
  final int activeTab;
  final PlatformException platformException;
  final List<Ubigeo> ubigeos;
  final List<Bank> banks;
  final List<BankAccount> bankAccounts;
  final ChangeRequest changeRequest;
  final List<History> historys;
  final List<ChangeRequest> changeRequests;
  final RequestData requestData;

  AppState({
    this.isLoading = false,
    this.currentUser,
    this.activeTab = 0,
    // this.isBusy = false,
    this.platformException,
    this.ubigeos = const [],
    this.banks = const [],
    this.bankAccounts = const [],
    this.changeRequest,
    this.historys = const [],
    this.changeRequests = const [],
    this.requestData,
  });

  factory AppState.loading() => AppState(
        isLoading: true,
        // configRequest: ConfigRequest.init(),
        requestData: RequestData(),
      );

  AppState copyWith({
    bool isLoading,
    UserApp currentUser,
    AppTab activeTab,
    bool isBusy,
    List<Ubigeo> ubigeos,
    List<Bank> banks,
    List<BankAccount> bankAccounts,
    PlatformException platformException,
    Rate rate,
    Coupon coupon,
    ChangeRequest changeRequest,
    List<History> historys,
    ConfigRequest configRequest,
    List<ChangeRequest> changeRequests,
    PreferentialRate preferentialRate,
    RequestData requestData,
  }) =>
      AppState(
        isLoading: isLoading ?? this.isLoading,
        currentUser: currentUser ?? this.currentUser,
        activeTab: activeTab ?? this.activeTab,
        // isBusy: isBusy ?? this.isBusy,
        platformException: platformException ?? this.platformException,
        ubigeos: ubigeos ?? this.ubigeos,
        banks: banks ?? this.banks,
        bankAccounts: bankAccounts ?? this.bankAccounts,
        changeRequest: changeRequest ?? this.changeRequest,
        historys: historys ?? this.historys,
        changeRequests: changeRequests ?? this.changeRequests,
        requestData: requestData ?? this.requestData,
      );

  static AppState fromJson(dynamic json) {
    if (json == null) {
      return AppState.loading();
    } else {
      return AppState.loading().copyWith(
        currentUser: UserApp.fromJson(json['current_user']),
      );
    }
  }

  dynamic toJson() => {
        'current_user': currentUser != null ? currentUser.toJson() : null,
      };

  @override
  int get hashCode =>
      isLoading.hashCode ^
      currentUser.hashCode ^
      // isBusy.hashCode ^
      activeTab.hashCode ^
      ubigeos.hashCode ^
      banks.hashCode ^
      bankAccounts.hashCode ^
      changeRequest.hashCode ^
      historys.hashCode ^
      changeRequests.hashCode ^
      requestData.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          // isBusy == other.isBusy &&
          activeTab == other.activeTab &&
          ubigeos == other.ubigeos &&
          banks == other.banks &&
          bankAccounts == other.bankAccounts &&
          changeRequest == other.changeRequest &&
          historys == other.historys &&
          changeRequests == other.changeRequests &&
          requestData == other.requestData;
}
