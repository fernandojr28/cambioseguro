import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/auth_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AuthFormContainer extends StatelessWidget {
  const AuthFormContainer({Key key, @required this.builder}) : super(key: key);

  final Function(BuildContext context, _ViewModel vm) builder;
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (Store<AppState> store) {
        return _ViewModel.fromStore(store, context);
      },
      builder: builder,
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.onSubmitForm,
    @required this.platformException,
    @required this.signInWithGoogle,
    @required this.signInWithFacebook,
  });

  final Function(AuthFormData, ErrorCallback onError, VoidCallback onSuccess)
      onSubmitForm;
  final PlatformException platformException;
  final VoidCallback signInWithGoogle;
  final VoidCallback signInWithFacebook;

  static _ViewModel fromStore(Store<AppState> store, BuildContext context) {
    return _ViewModel(
        platformException: store.state.platformException,
        signInWithGoogle: () {
          store.dispatch(SignInWithGoogleAndPasswordRequestAction());
        },
        signInWithFacebook: () {
          store.dispatch(SignInWithFacebookAndPasswordRequestAction());
        },
        onSubmitForm: (AuthFormData authData, onError, onSuccess) {
          if (authData.submitType == EmailPasswordSignInFormType.signIn &&
              authData.isValidLogIn)
            store.dispatch(SignInWithEmailAndPasswordRequestAction(
                authData, onSuccess, onError));

          if (authData.submitType == EmailPasswordSignInFormType.register &&
              authData.isValidRegister)
            store.dispatch(SignUpWithEmailAndPasswordRequestAction(
                authData, onSuccess, onError));
          if (authData.submitType ==
                  EmailPasswordSignInFormType.forgotPassword &&
              authData.isValidRecovery)
            store.dispatch(
                RecoverPasswordRequestAction(authData, onSuccess, onError));
        });
  }
}
