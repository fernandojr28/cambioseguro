import 'package:cambioseguro/redux/actions/app_actions.dart';
import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/account_form_data.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/bank.dart';
import 'package:cambioseguro/models/bank_account.dart';
import 'package:cambioseguro/models/ubigeo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AccountFormContainer extends StatelessWidget {
  const AccountFormContainer({Key key, @required this.builder})
      : super(key: key);

  final Function(BuildContext context, _ViewModel vm) builder;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.fromStore,
      builder: builder,
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.ubigeos,
    @required this.fetchBanks,
    @required this.banks,
    @required this.submitForm,
    @required this.formException,
    @required this.onLoadBankAccounts,
    @required this.bankAccounts,
  });

  final List<Ubigeo> ubigeos;
  final Function(String, VoidCallback, ErrorCallback) fetchBanks;
  final List<Bank> banks;
  final List<BankAccount> bankAccounts;
  final Function(AccountFormData formData, VoidCallback onSuccess,
      ErrorCallback onError) submitForm;
  final PlatformException formException;
  final VoidCallback onLoadBankAccounts;

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
      bankAccounts: store.state.bankAccounts,
      ubigeos: store.state.ubigeos,
      banks: store.state.banks,
      formException: store.state.platformException,
      onLoadBankAccounts: () =>
          store.dispatch(LoadBanksAccountsRequestAction()),
      fetchBanks: (String ubigeoId, onSuccess, onError) {
        return store.dispatch(LoadBanksRequestAction(
          ubigeoId,
          onSuccess,
          onError,
        ));
      },
      submitForm: (formData, onSuccess, onError) {
        if (formData.isValid()) {
          return store.dispatch(
            SaveBankAccountRequestAction(
              data: formData,
              onCompeleted: onSuccess,
              onError: onError,
            ),
          );
        }
      });
}
