import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/auth_data.dart';
import 'package:cambioseguro/models/user_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SignInWithEmailAndPasswordRequestAction {
  SignInWithEmailAndPasswordRequestAction(
      this.authForm, this.onSuccess, this.onError);
  final AuthFormData authForm;
  final VoidCallback onSuccess;
  final ErrorCallback onError;
}

class LogInFailResponseAction {
  LogInFailResponseAction(this.error);
  final PlatformException error;
}

class SignUpWithEmailAndPasswordRequestAction {
  SignUpWithEmailAndPasswordRequestAction(
      this.authForm, this.onSuccess, this.onError);
  final AuthFormData authForm;
  final VoidCallback onSuccess;
  final ErrorCallback onError;
}

class SignUpFailResponseAction {
  SignUpFailResponseAction(this.error);
  final dynamic error;
}

class RecoverPasswordRequestAction {
  RecoverPasswordRequestAction(this.authForm, this.onSuccess, this.onError);
  final AuthFormData authForm;
  final VoidCallback onSuccess;
  final ErrorCallback onError;
}

class LogInRequiredAction {}

class LogInSuccessfulResponseAction {
  final UserApp user;
  final VoidCallback onCompeleted;
  final ErrorCallback onError;

  LogInSuccessfulResponseAction(this.user, {this.onError, this.onCompeleted});
}

class RecoverPasswordSuccesfulResponseAction {
  RecoverPasswordSuccesfulResponseAction(this.authForm);
  final AuthFormData authForm;
}

class RecoverPasswordFailResponseAction {
  final PlatformException error;
  RecoverPasswordFailResponseAction(this.error);
}

class LogoutRequestAction {}

class LogoutResponseSuccesstAction {}

class LogoutResponseFailSuccesstAction {
  final PlatformException error;

  LogoutResponseFailSuccesstAction(this.error);
}

class SignInWithGoogleAndPasswordRequestAction {}

class SignInWithFacebookAndPasswordRequestAction {}

class LoadUserDataSuccessResponseAction {
  final UserApp user;

  LoadUserDataSuccessResponseAction(this.user);
}

class ChangePasswordRequestAction {
  final String password;
  final String password2;
  final VoidCallback onSuccess;
  final ErrorCallback onError;

  ChangePasswordRequestAction(
      this.password, this.password2, this.onSuccess, this.onError);
}

class UpdateUSerDataRequestAction {
  final UserApp user;

  UpdateUSerDataRequestAction(this.user);
}
