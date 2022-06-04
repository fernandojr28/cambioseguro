import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/models.dart';
import 'package:cambioseguro/presentation/home/tab_change.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cambioseguro/redux/actions/actions.dart';

class ChangeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return TabChange(
          bankAccounts: vm.bankAccounts,
          onRequestChange: vm.onRequestChange,
          currentUser: vm.currentUser,
          requestData: vm.requestData,
        );
      },
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.bankAccounts,
    @required this.onRequestChange,
    @required this.currentUser,
    @required this.requestData,
  });
  final List<BankAccount> bankAccounts;
  final Function(RequestData, VoidCallback, ErrorCallback) onRequestChange;
  final UserApp currentUser;
  final RequestData requestData;

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
        requestData: store.state.requestData,
        currentUser: store.state.currentUser,
        bankAccounts: store.state.bankAccounts,
        onRequestChange: (RequestData formData, VoidCallback onCompeleted,
                ErrorCallback onError) =>
            store
                .dispatch(RequestChangeAction(formData, onCompeleted, onError)),
      );
}
