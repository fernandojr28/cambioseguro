import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:redux/redux.dart';

final isBusyReducer = combineReducers<bool>([
  TypedReducer<bool, SignInWithEmailAndPasswordRequestAction>(_setBusy),
  TypedReducer<bool, SignUpWithEmailAndPasswordRequestAction>(_setBusy),
  TypedReducer<bool, RecoverPasswordRequestAction>(_setBusy),
  TypedReducer<bool, LogInFailResponseAction>(_setNotBusy),
  TypedReducer<bool, SignUpFailResponseAction>(_setNotBusy),
  TypedReducer<bool, LogInSuccessfulResponseAction>(_setNotBusy),
  TypedReducer<bool, RecoverPasswordSuccesfulResponseAction>(_setNotBusy),
  TypedReducer<bool, RecoverPasswordFailResponseAction>(_setNotBusy),
  TypedReducer<bool, InitAppAction>(_setBusy),
  TypedReducer<bool, LogInRequiredAction>(_setNotBusy),
]);

bool _setBusy(bool state, action) => true;

bool _setNotBusy(bool state, action) => false;
