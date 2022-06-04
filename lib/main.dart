import 'package:cambioseguro/abstract/abs.dart';
import 'package:cambioseguro/redux/middleware/middleware.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/redux/reducers/app_state_reducer.dart';
import 'package:cambioseguro/repository/repository.dart';
import 'package:cambioseguro/routes.dart';
import 'package:cambioseguro/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:intl/date_symbol_data_local.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

Future<void> main({
  UserRepositoryAbs userRepository,
  AppRepositoryAbs appRepository,
  FileRepositoryAbs fileRepository,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create Persistor
  final persistor = Persistor<AppState>(
    storage: FlutterStorage(
      location: FlutterSaveLocation.sharedPreferences,
    ),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
  );
  // Load initial state
  final initialState = await persistor.load();
  await initializeDateFormatting("es_US", null);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(CambioSeguroApp(
    localStore: initialState,
    persistor: persistor,
    userRepository: userRepository,
    appRepository: appRepository,
    fileRepository: fileRepository,
    navigatorKey: navigatorKey,
  ));
}

class CambioSeguroApp extends StatelessWidget {
  final Store<AppState> store;
  final GlobalKey<NavigatorState> navigatorKey;
  CambioSeguroApp({
    Key key,
    @required localStore,
    @required persistor,
    @required UserRepositoryAbs userRepository,
    @required AppRepository appRepository,
    @required FileRepositoryAbs fileRepository,
    @required GlobalKey<NavigatorState> navigatorKey,
  })  : navigatorKey = navigatorKey,
        store = Store<AppState>(appReducer,
            initialState: localStore ?? AppState.loading(),
            middleware: [
              persistor.createMiddleware(),
              ...createAuthMiddleware(
                  navigatorKey, userRepository ?? UserRepository()),
              ...createAppMiddleware(appRepository ?? AppRepository(database)),
              ...createFileMiddleware(fileRepository ?? FileRepository()),
            ]),
        super(key: key) {
    store.dispatch(InitAppAction(store.state.currentUser));
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        // navigatorObservers: [routeObserver],
        title: "Cambio Seguro",
        theme: AppTheme.theme,
        localizationsDelegates: [
          // ArchSampleLocalizationsDelegate(),
          // ReduxLocalizationsDelegate(),
        ],
        routes: getRoutes(context, store),
        onGenerateRoute: (RouteSettings settings) => getGenerateRoute(settings),
      ),
    );
  }
}
