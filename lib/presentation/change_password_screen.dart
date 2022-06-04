import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/shared/text_styles.dart';
import 'package:cambioseguro/widgets/form_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:cambioseguro/helpers/helpers.dart' as helpers;
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  FocusNode _passwordFocusNode;
  FocusNode _password2FocusNode;
  String password;
  String password2;
  bool _isBusy = false;

  @override
  initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _password2FocusNode = FocusNode();
  }

  @override
  dispose() {
    _unfocus();
    _passwordFocusNode?.dispose();
    _password2FocusNode?.dispose();
    super.dispose();
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      focusNode: _passwordFocusNode,
      obscureText: true,
      enableInteractiveSelection: false,
      onChanged: (value) => password = value,
      decoration: InputDecoration(
        hintText: 'Ingrese contraseña',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      validator: (value) => helpers.validatePassword(value),
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
      focusNode: _password2FocusNode,
      obscureText: true,
      // enableInteractiveSelection: false,
      onChanged: (value) => password2 = value,
      decoration: InputDecoration(
        hintText: 'Ingrese contraseña',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      validator: (value) => helpers.confirmPassword(password, value),
    );
  }

  _unfocus() {
    _passwordFocusNode?.unfocus();
    _password2FocusNode?.unfocus();
  }

  void _onSuccess() {
    // Navigation.of(context).pop();
    _setIsBusy(false);
    // StoreProvider.of<AppState>(context).dispatch(Navigator.of(context).pop());
  }

  void _onError(PlatformException error) {
    _setIsBusy(false);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        error.message,
        style: snackbarError,
      ),
    ));
  }

  _setIsBusy(bool _busy) => setState(() => _isBusy = _busy);

  void _handleSubmitForm() {
    _unfocus();
    _setIsBusy(true);
    final FormState _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      StoreProvider.of<AppState>(context).dispatch(ChangePasswordRequestAction(
          password, password2, _onSuccess, _onError));
    }
  }

  Widget _buildButton() {
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
            onPressed: _handleSubmitForm,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Cambiar contraseña'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Nueva contraseña'),
              UIHelper.verticalSpaceMiniSmall,
              _buildPasswordTextField(),
              UIHelper.verticalSpaceMedium,
              Text('Confirmar nueva contraseña'),
              UIHelper.verticalSpaceMiniSmall,
              _buildConfirmPasswordTextField(),
              UIHelper.verticalSpaceLarge,
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }
}
