import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/bank_account.dart';
import 'package:cambioseguro/models/change_request.dart';
import 'package:cambioseguro/models/request_data.dart';
import 'package:cambioseguro/models/user_app.dart';
import 'package:cambioseguro/presentation/home_screen.dart';
import 'package:cambioseguro/presentation/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cambioseguro/redux/actions/actions.dart';

class HomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        if (vm.isLoading ||
            vm.currentUser == null ||
            !vm.currentUser.data.isLoaded ||
            !vm.requestData.isComplete) return SplashScreen();
        return HomeScreen(
          activeTab: vm.activeTab,
          currentUser: vm.currentUser,
          logout: vm.onLogout,
          onInitHome: vm.onInitHome,
          changeRequest: vm.changeRequest,
        );
      },
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.activeTab,
    @required this.currentUser,
    @required this.onLogout,
    @required this.bankAccounts,
    @required this.onInitHome,
    @required this.onRequestChange,
    @required this.onDeleteRequest,
    @required this.changeRequest,
    @required this.isLoading,
    @required this.requestData,
  });
  final int activeTab;
  final UserApp currentUser;
  final Function onLogout;
  final List<BankAccount> bankAccounts;
  final VoidCallback onInitHome;
  final Function(RequestData, VoidCallback, ErrorCallback) onRequestChange;

  final VoidCallback onDeleteRequest;
  final ChangeRequest changeRequest;
  final bool isLoading;
  final RequestData requestData;

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
        requestData: store.state.requestData,
        isLoading: store.state.isLoading,
        bankAccounts: store.state.bankAccounts,
        currentUser: store.state.currentUser,
        activeTab: store.state.activeTab,
        changeRequest: store.state.changeRequest,
        onInitHome: () => store.dispatch(LoadBanksAccountsRequestAction()),
        onLogout: () => store.dispatch(LogoutRequestAction()),
        onRequestChange: (RequestData formData, VoidCallback onCompeleted,
                ErrorCallback onError) =>
            store
                .dispatch(RequestChangeAction(formData, onCompeleted, onError)),
        onDeleteRequest: () => store.dispatch(
          RequestChangeDeleteRequestAction(),
        ),
      );
}
