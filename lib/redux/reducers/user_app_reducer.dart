import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/models/user_app.dart';
import 'package:redux/redux.dart';

final userAppReducer = combineReducers<UserApp>([
  TypedReducer<UserApp, LogoutResponseSuccesstAction>(_cleanUser),
  TypedReducer<UserApp, LoadUserDataSuccessResponseAction>(_setUserData),
]);

UserApp _setUserData(
    UserApp currentUser, LoadUserDataSuccessResponseAction action) => action.user;

UserApp _cleanUser(UserApp state, action) => null;
