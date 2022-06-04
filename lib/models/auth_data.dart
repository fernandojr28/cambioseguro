import 'package:cambioseguro/enums/enum.dart';
import 'package:meta/meta.dart';

enum EmailPasswordSignInFormType { signIn, register, forgotPassword }

@immutable
class AuthFormData {
  final String email;
  final String password;
  final String confirmPassword;
  final String ruc;
  final String businessName;
  final bool acceptTerms;
  final AccountType type;
  final EmailPasswordSignInFormType submitType;
  final bool isBusy;

  AuthFormData({
    @required String email,
    String password,
    String confirmPassword,
    String ruc,
    String businessName,
    bool acceptTerms,
    AccountType type,
    EmailPasswordSignInFormType submitType,
    bool isBusy,
  })  : this.email = email ?? '',
        this.password = password ?? '',
        this.confirmPassword = confirmPassword ?? '-',
        this.ruc = ruc ?? '',
        this.businessName = businessName ?? '',
        this.acceptTerms = acceptTerms ?? false,
        this.type = type ?? AccountType.Natural,
        this.submitType = submitType ?? EmailPasswordSignInFormType.signIn,
        this.isBusy = isBusy ?? false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = Map<String, dynamic>();
    result['email'] = this.email;

    if (this.submitType != EmailPasswordSignInFormType.forgotPassword) {
      result['password'] = this.password;
      if (this.submitType != EmailPasswordSignInFormType.signIn)
        result['account_type'] = this.type.toString().split('.')[1];
    }

    if (this.submitType == EmailPasswordSignInFormType.register)
      result['password2'] = this.confirmPassword;

    if (this.submitType == EmailPasswordSignInFormType.register &&
        this.type == AccountType.Juridica) {
      result['business_name'] = this.businessName;
      result['ruc'] = this.ruc;
    }

    return result;
  }

  bool get isValidRegister => type == AccountType.Natural
      ? email.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          acceptTerms
      : email.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          ruc.isNotEmpty &&
          businessName.isNotEmpty &&
          acceptTerms;

  bool get isValidLogIn => email.isNotEmpty && password.isNotEmpty;
  bool get isValidRecovery => email.isNotEmpty;

  bool get isNeedTerms => submitType == EmailPasswordSignInFormType.register;
}
