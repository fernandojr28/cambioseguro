import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/bank_account.dart';
import 'package:cambioseguro/selectors/selectors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class BankAccountDetail extends StatelessWidget {
  final Function(BuildContext context, _ViewModel vm) builder;
  final String historyId;

  const BankAccountDetail(
      {Key key, @required this.builder, @required this.historyId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(store, historyId),
      builder: builder,
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.bankAccount,
    @required this.onUpdate,
  });

  final BankAccount bankAccount;

  final Function(BankAccount, VoidCallback, ErrorCallback) onUpdate;

  static _ViewModel fromStore(Store<AppState> store, String id) {
    final BankAccount account =
        bankAccountSelector(store.state.bankAccounts, id).value;
    return _ViewModel(
        bankAccount: account,
        onUpdate: (BankAccount newBankAccount, onSuccess, onError) {
          store.dispatch(EditBankAccountRequestAction(
              bankAccount: newBankAccount,
              onCompeleted: onSuccess,
              onError: onError));
        });
  }
}
