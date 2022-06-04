import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/user_app.dart';
import 'package:cambioseguro/presentation/home/tab_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cambioseguro/redux/actions/actions.dart';

class UserDataContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return TabAccount(
          // onInitHistory: vm.onInitHistory,
          currentUser: vm.currentUser,
        );
      },
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.onInitHistory,
    @required this.currentUser,
  });
  final VoidCallback onInitHistory;
  final UserApp currentUser;

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
        currentUser: store.state.currentUser,
        onInitHistory: () => store.dispatch(FetchHistorysRequest()),
      );
}
