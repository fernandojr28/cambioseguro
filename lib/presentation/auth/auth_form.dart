import 'package:cambioseguro/containers/auth_form_container.dart';
import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/helpers/helpers.dart' as helpers;
import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/auth_data.dart';
import 'package:cambioseguro/shared/app_colors.dart';
import 'package:cambioseguro/shared/app_icons.dart';
import 'package:cambioseguro/shared/text_styles.dart';
import 'package:cambioseguro/widgets/custom_checkbox.dart';
import 'package:cambioseguro/widgets/form_submit_button.dart';
import 'package:cambioseguro/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key key,
    @required this.formType,
    @required this.buttonText,
    @required this.updateFormType,
    @required this.authType,
    @required this.scrollController,
  }) : super(key: key);

  final EmailPasswordSignInFormType formType;
  final String buttonText;
  final Function(EmailPasswordSignInFormType) updateFormType;
  final AccountType authType;
  final ScrollController scrollController;

  @override
  _AuthFormState createState() => new _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  EmailPasswordSignInFormType get _formType => widget.formType;
  bool terms = false;
  bool isCheckTerms = false;
  bool isBusy = false;
  PlatformException _platformException;
  String get buttonText => widget.buttonText;

  bool _isEnableButton = false;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _rucFocusNode = FocusNode();
  final FocusNode _businessNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordconfirmFocusNode = FocusNode();

  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  final TextEditingController _rucTextController = TextEditingController();
  final TextEditingController _businessNameTextController =
      TextEditingController();

  @override
  void initState() {
    _emailTextController.addListener(_isEnableButtonF);
    _passwordTextController.addListener(_isEnableButtonF);
    _confirmPasswordTextController.addListener(_isEnableButtonF);
    _rucTextController.addListener(_isEnableButtonF);
    _businessNameTextController.addListener(_isEnableButtonF);
    super.initState();
  }

  @override
  void dispose() {
    _emailTextController?.dispose();
    _passwordTextController?.dispose();
    _confirmPasswordTextController?.dispose();
    _rucTextController?.dispose();
    _businessNameTextController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AuthForm oldWidget) {
    if (widget.authType != oldWidget.authType) _clearForm();
    super.didUpdateWidget(oldWidget);
  }

  void _updateFormType(EmailPasswordSignInFormType type) {
    _clearForm();
    return widget.updateFormType(type);
  }

  void _clearForm() {
    if (!mounted) return;
    _formKey.currentState?.reset();
    _unfocus();

    setState(() {
      terms = false;
      _emailTextController.text = "";
      _passwordTextController.text = "";
      _confirmPasswordTextController.text = "";
      _rucTextController.text = "";
      _businessNameTextController.text = "";
    });
  }

  void _unfocus() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    _passwordconfirmFocusNode.unfocus();
    _rucFocusNode.unfocus();
    _businessNameFocusNode.unfocus();
  }

  void _isEnableButtonF() {
    if (!mounted) return;
    bool _isEnable = false;
    final AuthFormData data = AuthFormData(
      email: _emailTextController.text,
      password: _passwordTextController.text,
      confirmPassword: _confirmPasswordTextController.text,
      submitType: _formType,
      type: widget.authType,
      acceptTerms: terms,
      businessName: _businessNameTextController.text,
      ruc: _rucTextController.text,
    );
    if (_formType == EmailPasswordSignInFormType.forgotPassword)
      _isEnable = data.isValidRecovery;

    if (_formType == EmailPasswordSignInFormType.signIn)
      _isEnable = data.isValidLogIn;

    if (_formType == EmailPasswordSignInFormType.register)
      _isEnable = data.isValidRegister;

    setState(() {
      _isEnableButton = _isEnable;
    });
  }

  void _updateTerms(bool value) {
    setState(() {
      terms = value;
      isCheckTerms = !terms;
    });
    _isEnableButtonF();
  }

  _setBusy(bool isb, PlatformException error) => setState(() {
        isBusy = isb;
        _platformException = error;
      });

  _onSuccess() {
    _setBusy(false, null);
  }

  _onError(PlatformException error) {
    _setBusy(false, error);
  }

  void _handleSubmitted(
      Function(AuthFormData, ErrorCallback, VoidCallback) vmSubmit) {
    _unfocus();

    final FormState _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      _setBusy(true, null);
      final AuthFormData data = AuthFormData(
        email: _emailTextController.text,
        password: _passwordTextController.text,
        confirmPassword: _confirmPasswordTextController.text,
        submitType: _formType,
        type: widget.authType,
        acceptTerms: terms,
        businessName: _businessNameTextController.text,
        ruc: _rucTextController.text,
      );
      if (data.isNeedTerms) {
        setState(() => isCheckTerms = !terms);
        if (terms) vmSubmit(data, _onError, _onSuccess);
      } else {
        vmSubmit(data, _onError, _onSuccess);
      }
    }
  }

  Widget _buildRucField() {
    return TextFormField(
      controller: _rucTextController,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      focusNode: _rucFocusNode,
      maxLength: 11,
      decoration: InputDecoration(
        prefixIcon: Icon(AppIcons.user),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: "Ingresa RUC",
        labelText: "RUC",
      ),
      validator: (value) => helpers.validateRuc(value),
    );
  }

  Widget _buildBusinessNameField() {
    return TextFormField(
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      focusNode: _businessNameFocusNode,
      decoration: InputDecoration(
        prefixIcon: Icon(AppIcons.user),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: "Ingresa tu razón social",
        labelText: "Razón social",
      ),
      validator: (value) => helpers.validateText(value),
      controller: _businessNameTextController,
    );
  }

  Widget _buildEmailField() {
    IconData _idata = _formType == EmailPasswordSignInFormType.forgotPassword
        ? AppIcons.at
        : AppIcons.user;
    return TextFormField(
      enableInteractiveSelection: false,
      keyboardType: TextInputType.emailAddress,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        prefixIcon: Icon(_idata),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: "Ingresa tu correo electrónico",
        labelText: "Correo electrónico",
      ),
      validator: (value) => helpers.validateEmail(value),
      controller: _emailTextController,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
        enableInteractiveSelection: false,
        obscureText: true,
        focusNode: _passwordFocusNode,
        decoration: InputDecoration(
          prefixIcon: Icon(AppIcons.lockAlt),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          hintText: "Ingrese su contraseña",
          labelText: "Contraseña",
        ),
        validator: (value) => helpers.validatePassword(value),
        controller: _passwordTextController);
  }

  Widget _buildPasswordConfirmField() {
    return TextFormField(
      enableInteractiveSelection: false,
      obscureText: true,
      focusNode: _passwordconfirmFocusNode,
      decoration: InputDecoration(
        prefixIcon: Icon(AppIcons.lockAlt),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: "Contraseña no coincide",
        labelText: "Confirmar contraseña",
      ),
      validator: (value) =>
          helpers.confirmPassword(_confirmPasswordTextController.text, value),
      controller: _confirmPasswordTextController,
    );
  }

  Widget _buildSocialRow(
      VoidCallback signInWithGoogle, VoidCallback signInWithFacebook) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: SocialButton(
            icon: Icon(
              FontAwesomeIcons.facebookF,
              size: 16,
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "|",
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
                SizedBox(width: 8),
                Text("Facebook", style: TextStyle(color: Colors.white))
              ],
            ),
            type: SocialType.Facebook,
            onPressed: () => signInWithFacebook(),
          ),
        ),
        UIHelper.horizontalSpaceMedium,
        Expanded(
          child: SocialButton(
            icon: Icon(
              FontAwesomeIcons.googlePlusG,
              size: 16,
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "|",
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
                SizedBox(width: 8),
                Text("Google", style: TextStyle(color: Colors.white))
              ],
            ),
            type: SocialType.Google,
            onPressed: () => signInWithGoogle(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthFormContainer(
      builder: (BuildContext context, vm) {
        List items = [];
        items.add(UIHelper.verticalSpaceSmall);
        if (_formType == EmailPasswordSignInFormType.register &&
            widget.authType == AccountType.Juridica)
          items.addAll([
            _buildRucField(),
            UIHelper.verticalSpaceSmall,
            _buildBusinessNameField(),
            UIHelper.verticalSpaceMedium,
          ]);
        if (_formType == EmailPasswordSignInFormType.forgotPassword)
          items.add(UIHelper.verticalSpaceMedium);

        items.add(_buildEmailField());

        if (_formType != EmailPasswordSignInFormType.forgotPassword)
          items.addAll([
            UIHelper.verticalSpaceMedium,
            _buildPasswordField(),
          ]);
        if (_formType == EmailPasswordSignInFormType.register)
          items.addAll([
            UIHelper.verticalSpaceMedium,
            _buildPasswordConfirmField(),
            UIHelper.verticalSpaceMedium,
            ListTile(
              // dense: true,
              contentPadding: EdgeInsets.all(0),
              leading: Transform.scale(
                scale: 1.8,
                child: CustomCheckbox(
                  activeColor: primaryColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: terms,
                  onChanged: _updateTerms,
                ),
              ),
              title: Text(
                "Acepto los términos, condiciones y la política de privacidad.",
              ),
            ),
          ]);
        if (_isEnableButton &&
            isCheckTerms &&
            _formType == EmailPasswordSignInFormType.register)
          items.add(Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                "Debe aceptar los términos",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Colors.red[700]),
              ),
            ),
          ));
        if (_formType != EmailPasswordSignInFormType.forgotPassword &&
            _formType != EmailPasswordSignInFormType.register)
          items.addAll([
            UIHelper.verticalSpaceMedium,
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () =>
                    _updateFormType(EmailPasswordSignInFormType.forgotPassword),
                child: Text(
                  "¿Olvidaste tu contraseña?",
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ]);
        if (!isBusy && _platformException != null)
          items.addAll([
            UIHelper.verticalSpaceMedium,
            _buildErrorMessage(_platformException)
          ]);
        items.add(UIHelper.verticalSpaceMedium);
        items.add(Container(
          width: double.infinity,
          child: FormSubmitButton(
            child: Text(
              buttonText,
              style: buttonStyle,
            ),
            loading: isBusy,
            onPressed: _isEnableButton
                ? () => _handleSubmitted(vm.onSubmitForm)
                : null,
          ),
        ));
        if (_formType == EmailPasswordSignInFormType.forgotPassword)
          items.addAll([
            UIHelper.verticalSpaceMedium,
            Container(
              width: double.infinity,
              child: FormSubmitButton(
                color: Colors.white,
                child: Text(
                  "Cancelar",
                  style: buttonStyle.copyWith(color: primaryColor),
                ),
                onPressed: () =>
                    _updateFormType(EmailPasswordSignInFormType.signIn),
              ),
            ),
          ]);
        if (widget.authType == AccountType.Natural &&
            _formType != EmailPasswordSignInFormType.forgotPassword)
          items.addAll([
            UIHelper.verticalSpaceMedium,
            if (_formType == EmailPasswordSignInFormType.signIn)
              Center(child: Text("También puedes iniciar sesión con")),
            if (_formType == EmailPasswordSignInFormType.register)
              Center(child: Text("También puedes registrarte con")),
            UIHelper.verticalSpaceMedium,
            _buildSocialRow(vm.signInWithGoogle, vm.signInWithFacebook),
          ]);
        items.add(UIHelper.verticalSpaceLarge);
        if (_formType == EmailPasswordSignInFormType.signIn)
          items.add(Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "¿No tienes una cuenta?",
                style: TextStyle(color: Colors.black),
              ),
              InkWell(
                child: Text(
                  "Regístrate aquí",
                  style: TextStyle(color: primaryColor),
                ),
                onTap: () =>
                    _updateFormType(EmailPasswordSignInFormType.register),
              ),
            ],
          ));
        if (_formType == EmailPasswordSignInFormType.register)
          items.add(BuildNotPadding(
            child: Container(
              color: Colors.black.withOpacity(0.1),
              padding: EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  Text("Ya tengo una cuenta"),
                  UIHelper.verticalSpaceMedium,
                  UIHelper.verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () =>
                            _updateFormType(EmailPasswordSignInFormType.signIn),
                        child: Text("Iniciar sesión",
                            style: TextStyle(color: primaryColor)),
                      ),
                      InkWell(
                        onTap: () => _updateFormType(
                            EmailPasswordSignInFormType.forgotPassword),
                        child: Text(
                          "Olvide mi contraseña",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
        return Form(
          key: _formKey,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            controller: widget.scrollController,
            itemCount: items.length,
            padding: EdgeInsets.only(top: 20),
            itemBuilder: (context, index) => items[index] is BuildNotPadding
                ? items[index]
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: items[index],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildErrorMessage(PlatformException authEx) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text("${authEx.message}",
          style: TextStyle(
            color: Colors.red,
          )),
    );
  }
}

class BuildNotPadding extends StatelessWidget {
  final Widget child;

  const BuildNotPadding({Key key, @required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return child;
  }
}
