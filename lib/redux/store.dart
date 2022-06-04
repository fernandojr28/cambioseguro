import 'package:cambioseguro/abstract/abs.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/redux/reducers/app_state_reducer.dart';
import 'package:cambioseguro/redux/middleware/middleware.dart';
import 'package:cambioseguro/repository/repository.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';

Future<Store<AppState>> createStore(
  UserRepositoryAbs userRepository,
  AppRepositoryAbs appRepository,
  FileRepositoryAbs fileRepository,
) async {

  final FirebaseDatabase database = FirebaseDatabase.instance;

  final persistor = Persistor<AppState>(
    storage: FlutterStorage(
      location: FlutterSaveLocation.sharedPreferences,
    ),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
  );

   final initialState = await persistor.load();

   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

   var middlewares = [
     persistor.createMiddleware(),
      ...createAuthMiddleware(
          navigatorKey, userRepository ?? UserRepository()),
      ...createAppMiddleware(appRepository ?? AppRepository(database)),
      ...createFileMiddleware(fileRepository ?? FileRepository()),
   ]; 

  return Store(
    appReducer,
    initialState: initialState ?? AppState.loading(),
    middleware: middlewares
  );
}
