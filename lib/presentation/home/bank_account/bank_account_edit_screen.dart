import 'package:cambioseguro/containers/bank_acount_detail.dart';
import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/bank_account.dart';
import 'package:cambioseguro/shared/text_styles.dart';
import 'package:cambioseguro/widgets/form_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:cambioseguro/helpers/helpers.dart' as helpers;
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BankAccountEditScreen extends StatefulWidget {
  const BankAccountEditScreen({Key key, @required this.accountId})
      : super(key: key);

  final String accountId;

  @override
  _BankAccountEditScreenState createState() => _BankAccountEditScreenState();
}

class _BankAccountEditScreenState extends State<BankAccountEditScreen> {
  bool _isBusy = false;
  FocusNode _aliasFocusNode;
  String alias;
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    _aliasFocusNode = FocusNode();
  }

  Widget _buildRow(title, subTitle) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('$title'),
            // UIHelper.horizontalSpaceMiniSmall,
            Text(
              '$subTitle',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        UIHelper.verticalSpaceSmall,
      ],
    );
  }

  Widget _buildAliasTextField(String initialText) {
    return TextFormField(
      focusNode: _aliasFocusNode,
      initialValue: initialText,
      enableInteractiveSelection: false,
      onChanged: (value) => alias = value,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      validator: (value) => helpers.validateText(value),
    );
  }

  void _unfocus() {
    _aliasFocusNode?.unfocus();
  }

  void _onSuccess() {
    // Navigation.of(context).pop();
    // StoreProvider.of<AppState>(context).dispatch(Navigator.of(context).pop());
  }

  void _onError(PlatformException error) {}

  void _handleSubmitForm(BankAccount bankAccount,
      Function(BankAccount, VoidCallback, ErrorCallback) onUpdate) {
    _unfocus();
    setState(() {
      _isBusy = true;
    });
    final FormState _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();

      onUpdate(bankAccount.copyWith(alias: alias), _onSuccess, _onError);
    }
  }

  Widget _buildButton(BankAccount bankAccount,
      Function(BankAccount, VoidCallback, ErrorCallback) onUpdate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: FormSubmitButton(
            color: Colors.grey,
            child: Text(
              "Cancelar",
              style: buttonStyle,
            ),
            // loading: vm.isBusy,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        UIHelper.horizontalSpaceLarge,
        Expanded(
          child: FormSubmitButton(
            child: Text(
              "Guardar",
              style: buttonStyle,
            ),
            loading: _isBusy,
            onPressed: () => _handleSubmitForm(bankAccount, onUpdate),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BankAccountDetail(
      historyId: widget.accountId,
      builder: (BuildContext context, vm) {
        final BankAccount bankAccount = vm.bankAccount;

        return Scaffold(
          appBar: AppBar(
            title: Text('Editar cuenta'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _buildRow('Banco', bankAccount.nameBank),
                  _buildRow('Tipo', bankAccount.bankAccountType),
                  _buildRow('Moneda', bankAccount.currencyType),
                  _buildRow('Domiciliada', bankAccount.nameUbigeo),
                  UIHelper.verticalSpaceLarge,
                  Text('Alias de la cuenta'),
                  UIHelper.verticalSpaceMedium,
                  _buildAliasTextField(bankAccount.alias),
                  UIHelper.verticalSpaceMedium,
                  _buildButton(bankAccount, vm.onUpdate),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
