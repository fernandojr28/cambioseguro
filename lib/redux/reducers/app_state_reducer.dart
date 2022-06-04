import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/redux/actions/auth_actions.dart';
import 'package:cambioseguro/redux/reducers/reducers.dart';

AppState appReducer(AppState state, action) {
  if (action is LogoutResponseSuccesstAction) return AppState();

  return AppState(
    // isBusy: isBusyReducer(state.isBusy, action),
    isLoading: loadingReducer(state.isLoading, action),
    activeTab: tabsReducer(state.activeTab, action),
    platformException:
        platformExceptionReducer(state.platformException, action),
    currentUser: userAppReducer(state.currentUser, action),
    // route: navigationReducer(state.route, action),
    ubigeos: ubigeosReducer(state.ubigeos, action),
    banks: banksReducer(state.banks, action),
    bankAccounts: bankAccountsReducer(state.bankAccounts, action),
    // rate: rateReducer(state.rate, action),
    // coupon: couponReducer(state.coupon, action),
    changeRequest: changeRequestReducer(state.changeRequest, action),
    historys: historyReducer(state.historys, action),
    // configRequest: configRequestReducer(state.configRequest, action),
    changeRequests: changeRequestsReducer(state.changeRequests, action),
    // preferentialRate: preferentialRateReducer(state.preferentialRate, action),
    requestData: requestDataReducer(state.requestData, action),
  );
}
