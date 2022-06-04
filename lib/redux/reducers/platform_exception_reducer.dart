import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

final platformExceptionReducer = combineReducers<PlatformException>([
  // Auth
  TypedReducer<PlatformException, LogInFailResponseAction>(_setException),
  TypedReducer<PlatformException, LogInSuccessfulResponseAction>(
      _removeException),
  TypedReducer<PlatformException, RecoverPasswordSuccesfulResponseAction>(
      _removeException),
  TypedReducer<PlatformException, RecoverPasswordFailResponseAction>(
      _setException),
  TypedReducer<PlatformException, SignUpFailResponseAction>(_setException),
  TypedReducer<PlatformException, RecoverPasswordFailResponseAction>(
      _setException),

  // banks_accounts
  TypedReducer<PlatformException, ErrorExceptionResponseAction>(_setException)
]);

PlatformException _setException(PlatformException state, action) =>
    action.error;

PlatformException _removeException(PlatformException state, action) => null;
