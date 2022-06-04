import 'package:cambioseguro/containers/account_form_container.dart';
import 'package:cambioseguro/shared/app_colors.dart';
import 'package:cambioseguro/widgets/bank_account_form.dart';
import 'package:flutter/material.dart';

class BankAccountScreen extends StatelessWidget {
  const BankAccountScreen(
      {Key key, this.isAccountSend = false, @required this.currency})
      : super(key: key);
  final bool isAccountSend;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // elevation: 0,
        backgroundColor: greyColor,
        title: Text('Agregar la cuenta de donde envías'),
        textTheme: TextTheme(
            headline6:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AccountFormContainer(
            builder: (BuildContext context, vm) => BankAccountForm(
              ubigeos: vm.ubigeos,
              fetchBanks: vm.fetchBanks,
              banks: vm.banks,
              submitForm: vm.submitForm,
              formException: vm.formException,
              isAccountSend: isAccountSend,
              onLoadBankAccounts: vm.onLoadBankAccounts,
              currency: currency,
            ),
          ),
        ],
      ),
    );
  }
}
