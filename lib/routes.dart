import 'package:cambioseguro/containers/home_container.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/presentation/auth/auth_intermediate_screen.dart';
import 'package:cambioseguro/presentation/auth/auth_screen.dart';
import 'package:cambioseguro/presentation/change_password_screen.dart';
import 'package:cambioseguro/presentation/history_detail.dart';
import 'package:cambioseguro/presentation/home/bank_account/bank_account_edit_screen.dart';
import 'package:cambioseguro/presentation/home/bank_account/bank_accounts_screen.dart';
import 'package:cambioseguro/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AppRoutes {
  static const splash = "/";
  static const auth = "/auth/";
  static const home = "/home";
  static const authIntermediate = "/auth/intermediate";
  static const historyDetail = "/history";
  static const bankAccounts = "/bankaccounts";
  static const bankAccount = "/bankaccount";
  static const changePassword = "/changepassword";
}

Map<String, WidgetBuilder> getRoutes(context, store) {
  return {
    AppRoutes.splash: (BuildContext context) => StoreBuilder<AppState>(
          builder: (context, store) => SplashScreen(),
        ),

    AppRoutes.home: (BuildContext context) => StoreBuilder<AppState>(
          builder: (context, store) => HomeContainer(),
        ),

    // case AppRoutes.auth:
    //   return AuthScreen();
    AppRoutes.authIntermediate: (BuildContext context) =>
        StoreBuilder<AppState>(
          builder: (context, store) => AuthIntermediateScreen(),
        ),

    AppRoutes.bankAccounts: (BuildContext context) => StoreBuilder<AppState>(
          builder: (context, store) => BankAccountsScreen(),
        ),

    AppRoutes.changePassword: (BuildContext context) => StoreBuilder<AppState>(
          builder: (context, store) => ChangePasswordScreen(),
        ),
  };
}

MaterialPageRoute getGenerateRoute(RouteSettings settings) {
  if (isPathNameWithRoute(settings, AppRoutes.auth)) {
    int _tab = getTabByPath(settings);

    return MaterialPageRoute<Null>(
      settings: settings,
      builder: (BuildContext context) => StoreBuilder<AppState>(
        builder: (context, store) => AuthScreen(initialTabIndex: _tab),
      ),
    );
  }
  if (isPathNameWithRoute(settings, AppRoutes.historyDetail)) {
    String _historyId = getIdByPath(settings);
    return MaterialPageRoute<Null>(
      settings: settings,
      builder: (BuildContext context) => StoreBuilder<AppState>(
        builder: (context, store) => HistoryDetail(historyId: _historyId),
      ),
    );
  }
  if (isPathNameWithRoute(settings, AppRoutes.bankAccount)) {
    String _accountId = getIdByPath(settings);

    return MaterialPageRoute<Null>(
      settings: settings,
      builder: (BuildContext context) => StoreBuilder<AppState>(
        builder: (context, store) =>
            BankAccountEditScreen(accountId: _accountId),
      ),
    );
  }
  return null;
}

bool isPathNameWithRoute(RouteSettings settings, String pathName) {
  final List<String> path = settings.name.split('/');
  final List<String> pathScreen = pathName.split('/');
  if (path[0] != '' || pathScreen[0] != '') return false;
  if (path[1].startsWith(pathScreen[1])) {
    if (path.length != 3) return false;
    return true;
  }
  return false;
}

String getIdByPath(RouteSettings settings) {
  final List<String> path = settings.name.split('/');
  return path[2] != "null" ? path.last : "___";
}

/// Ejemplo de llamada para un tab en específico:
/// /{routeName}/{id}#{initialTabIndex}
/// example:
///     /auth/ID0001#1
int getTabByPath(RouteSettings settings) {
  final List<String> path = settings.name.split('#');
  return path[1] != "null" ? int.parse(path.last) : 0;
}
