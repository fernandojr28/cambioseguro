import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/containers/account_form_container.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/bank_account.dart';
import 'package:cambioseguro/presentation/bank_account_screen.dart';
import 'package:cambioseguro/presentation/home/bank_account/bank_account_item.dart';
import 'package:cambioseguro/routes.dart';
import 'package:cambioseguro/shared/app_icons.dart';
import 'package:cambioseguro/shared/text_styles.dart';
import 'package:cambioseguro/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class BankAccountsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  void _showDialog(context, bool isSend) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BankAccountScreen(
          isAccountSend: isSend,
          currency: null,
        );
      },
    );
  }

  Widget _buildSendButtonStandalone(context) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          onTap: () => _showDialog(context, true),
          child: Card(
            elevation: 4,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Agregar cuenta bancaria",
                    style: selectTextStyle,
                  ),
                  Icon(
                    AppIcons.plusCircle,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
        ),
      );

  _onSuccess() {}

  void _onError(dynamic error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        error.message,
        style: snackbarError,
      ),
    ));
  }

  _confirmDialog(context, BankAccount bankAccount) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) => CustomDialog(
              title: '¿Estás seguro que deseas borrar la cuenta bancaria?',
              description:
                  'Sólo se pueden borrar las cuentas que no tienen operaciones pendiendes.',
              buttonText: 'Aceptar',
              onConfirm: () {
                final Store<AppState> provider =
                    StoreProvider.of<AppState>(context);
                provider.dispatch(DeleteBankAccountRequestAction(
                    bankAccount.id, _onSuccess, _onError));
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Mis cuentas bancarias'),
        centerTitle: true,
      ),
      body: AccountFormContainer(
        builder: (BuildContext context, vm) {
          final List items = [_buildSendButtonStandalone(context)];
          items.addAll(vm.bankAccounts);

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              if (items[index] is Widget) return items[index];
              final BankAccount bankAccount = items[index];
              return BankAccountItem(
                bankAccount: bankAccount,
                onEdit: () => StoreProvider.of<AppState>(context).dispatch(
                    Navigator.of(context).pushNamed(
                        "${AppRoutes.bankAccount}/${bankAccount.id}")),
                onDelete: () => _confirmDialog(context, bankAccount),
              );
            },
          );
        },
      ),
    );
  }
}
