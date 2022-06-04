import 'package:cambioseguro/abstract/user_repository_abs.dart';
import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/user_app.dart';
import 'package:cambioseguro/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAuthMiddleware(
  GlobalKey<NavigatorState> navigatorKey,
  UserRepositoryAbs userRepository,
) {
  return [
    TypedMiddleware<AppState, InitAppAction>(
      _handleSignIn(userRepository),
    ),
    TypedMiddleware<AppState, SignInWithEmailAndPasswordRequestAction>(
        _createLogInMiddleware(userRepository)),
    TypedMiddleware<AppState, SignUpWithEmailAndPasswordRequestAction>(
        _createSingUpMiddleware(userRepository)),
    TypedMiddleware<AppState, RecoverPasswordRequestAction>(
        _recoveryPasswordMiddleware(userRepository)),
    TypedMiddleware<AppState, LogoutRequestAction>(
        _logoutMiddleware(userRepository, navigatorKey)),
    TypedMiddleware<AppState, SignInWithGoogleAndPasswordRequestAction>(
        _loInWithGoogleMiddleware(userRepository)),
    TypedMiddleware<AppState, SignInWithFacebookAndPasswordRequestAction>(
        _loInWithFacebookMiddleware(userRepository)),
    TypedMiddleware<AppState, LogInSuccessfulResponseAction>(
        _loadUserData(userRepository)),
    TypedMiddleware<AppState, LoadUserDataSuccessResponseAction>(
        _navigate(userRepository, navigatorKey)),
    TypedMiddleware<AppState, LogInRequiredAction>(
        _navigate(userRepository, navigatorKey)),
    TypedMiddleware<AppState, ChangePasswordRequestAction>(
        _changePassword(userRepository)),

    //LOADERS
    TypedMiddleware<AppState, UpdateUSerDataRequestAction>(
        _loadUserData(userRepository)),

    TypedMiddleware<AppState, PullRefreshRequestAction>(
        _refreshIncrementMiddleware(userRepository)),
  ];
}

void Function(
  Store<AppState> store,
  InitAppAction action,
  NextDispatcher next,
) _handleSignIn(
  UserRepositoryAbs repository,
) {
  return (store, action, next) {
    repository.fetchUserData(action.user).then((UserApp user) {
      store.dispatch(LogInSuccessfulResponseAction(user));
    }).catchError((onError) {
      store.dispatch(LogInRequiredAction());
    }).whenComplete(() {
      next(action);
    });
  };
}

void Function(
  Store<AppState> store,
  SignInWithEmailAndPasswordRequestAction action,
  NextDispatcher next,
) _createLogInMiddleware(UserRepositoryAbs userRepository) {
  return (store, action, NextDispatcher next) async {
    userRepository.signInWithEmailAndPassword(action.authForm).then((user) {
      action.onSuccess();
      store.dispatch(LogInSuccessfulResponseAction(user));
    }).catchError((onError) {
      action.onError(onError);
      store.dispatch(LogInFailResponseAction(onError));
    }).whenComplete(() {
      next(action);
    });
  };
}

void Function(
  Store<AppState> store,
  SignUpWithEmailAndPasswordRequestAction action,
  NextDispatcher next,
) _createSingUpMiddleware(UserRepositoryAbs userRepository) {
  return (store, action, NextDispatcher next) async {
    userRepository.createUserWithEmailAndPassword(action.authForm).then((user) {
      store.dispatch(LogInSuccessfulResponseAction(user));
      action.onSuccess();
    }).catchError((onError) {
      store.dispatch(SignUpFailResponseAction(onError));
      action.onError(onError);
    }).whenComplete(() {
      next(action);
    });
  };
}

void Function(
  Store<AppState> store,
  RecoverPasswordRequestAction action,
  NextDispatcher next,
) _recoveryPasswordMiddleware(UserRepositoryAbs userRepository) {
  return (store, action, NextDispatcher next) async {
    next(action);
    userRepository.sendPasswordResetEmail(action.authForm).then((isSend) {
      action.onSuccess();
      store.dispatch(RecoverPasswordSuccesfulResponseAction(action.authForm));
    }).catchError((onError) {
      action.onError(onError);
      store.dispatch(RecoverPasswordFailResponseAction(onError));
    });
  };
}

void Function(
  Store<AppState> store,
  LogoutRequestAction action,
  NextDispatcher next,
) _logoutMiddleware(
    UserRepositoryAbs userRepository, GlobalKey<NavigatorState> navigatorKey) {
  return (store, action, NextDispatcher next) {
    store.dispatch(LogoutResponseSuccesstAction());
    navigatorKey.currentState.pushReplacementNamed("${AppRoutes.auth}#0");
    next(action);
  };
}

void Function(
  Store<AppState> store,
  SignInWithGoogleAndPasswordRequestAction action,
  NextDispatcher next,
) _loInWithGoogleMiddleware(UserRepositoryAbs userRepository) {
  return (store, action, NextDispatcher next) async {
    userRepository.signInWithGoogle().then((user) {
      store.dispatch(LogInSuccessfulResponseAction(user));
    }).catchError((onError) {
      store.dispatch(LogInFailResponseAction(onError));
    }).whenComplete(() {
      next(action);
    });
  };
}

void Function(
  Store<AppState> store,
  SignInWithFacebookAndPasswordRequestAction action,
  NextDispatcher next,
) _loInWithFacebookMiddleware(UserRepositoryAbs userRepository) {
  return (store, action, NextDispatcher next) async {
    userRepository.signInWithFacebook().then((user) {
      store.dispatch(LogInSuccessfulResponseAction(user));
    }).catchError((onError) {
      store.dispatch(LogInFailResponseAction(onError));
    }).whenComplete(() {
      next(action);
    });
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _loadUserData(UserRepositoryAbs repository) {
  return (store, action, next) {
    repository
        .fetchUserData(action.user ?? store.state.currentUser)
        .then((userApp) {
      store.dispatch(LoadUserDataSuccessResponseAction(userApp));
    }).catchError((handleError) {
      store.dispatch(LogInRequiredAction());
    }).whenComplete(() {
      next(action);
    });
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _navigate(
        UserRepositoryAbs repository, GlobalKey<NavigatorState> navigatorKey) {
  return (store, action, next) {
    next(action);
    if (action is LoadUserDataSuccessResponseAction)
      navigatorKey.currentState.pushReplacementNamed(AppRoutes.home);
    if (action is LogInRequiredAction)
      navigatorKey.currentState
          .pushReplacementNamed(AppRoutes.authIntermediate);
  };
}

void Function(Store<AppState> store, ChangePasswordRequestAction action,
    NextDispatcher next) _changePassword(UserRepositoryAbs repository) {
  return (store, action, next) {
    repository
        .changePassword(
            store.state.currentUser, action.password, action.password2)
        .then((userApp) {
      action.onSuccess();
    }).catchError((handleError) {
      action.onError(handleError);
    }).whenComplete(() {
      next(action);
    });
  };
}

void Function(
  Store<AppState> store,
  PullRefreshRequestAction action,
  NextDispatcher next,
) _refreshIncrementMiddleware(UserRepositoryAbs repository) {
  return (
    store,
    action,
    NextDispatcher next,
  ) {
    repository.fetchUserData(store.state.currentUser).then((UserApp user) {
      store.dispatch(LogInSuccessfulResponseAction(user));
    }).catchError((onError) {
      store.dispatch(LogInRequiredAction());
      action.completer.complete();
    }).whenComplete(() {
      action.completer.complete();
      next(action);
    });
  };
}
