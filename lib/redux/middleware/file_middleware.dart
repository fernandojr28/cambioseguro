import 'package:cambioseguro/abstract/abs.dart';
import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createFileMiddleware(
  FileRepositoryAbs repository,
) {
  return [
    TypedMiddleware<AppState, UploadPassportImageRequestAction>(
        _uploadPassport(repository)),
    TypedMiddleware<AppState, UploadRequestImageRequestAction>(
        _uploadRequestImage(repository)),
    TypedMiddleware<AppState, UploadBanksAccountsPassportAction>(
        _ploadBakAccountPassport(repository)),
  ];
}

void Function(
  Store<AppState> store,
  UploadPassportImageRequestAction action,
  NextDispatcher next,
) _uploadPassport(
  FileRepositoryAbs repository,
) {
  return (store, action, next) {
    repository
        .uploadPassport(store.state.currentUser, action.file)
        .then((String fileUrl) {
      action.onSuccess(fileUrl);
    }).catchError((error) {
      if (error is PlatformException) action.onError(error);
    }).whenComplete(() => next(action));
  };
}

void Function(
  Store<AppState> store,
  UploadRequestImageRequestAction action,
  NextDispatcher next,
) _uploadRequestImage(
  FileRepositoryAbs repository,
) {
  return (store, action, next) {
    repository
        .uploadRequestImage(
      store.state.currentUser,
      store.state.changeRequest.id,
      action.file,
      action.position,
    )
        .then((String fileUrl) {
      action.onSuccess(fileUrl);
    }).catchError((error) {
      if (error is PlatformException) action.onError(error);
    }).whenComplete(() => next(action));
  };
}

void Function(
  Store<AppState> store,
  UploadBanksAccountsPassportAction action,
  NextDispatcher next,
) _ploadBakAccountPassport(
  FileRepositoryAbs repository,
) {
  return (store, action, next) {
    repository
        .uploadBakAccountPassport(store.state.currentUser, action.file)
        .then((String fileUrl) {
      action.onSuccess(fileUrl);
    }).catchError((error) {
      if (error is PlatformException) action.onError(error);
    }).whenComplete(() => next(action));
  };
}
