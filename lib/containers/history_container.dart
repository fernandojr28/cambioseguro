import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/history.dart';
import 'package:cambioseguro/presentation/home/tab_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cambioseguro/redux/actions/actions.dart';

class HistoryContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return TabHistory(
          onInitHistory: vm.onInitHistory,
          historys: vm.historys,
        );
      },
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.onInitHistory,
    @required this.historys,
  });
  final VoidCallback onInitHistory;
  final List<History> historys;

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
        historys: store.state.historys,
        onInitHistory: () => store.dispatch(FetchHistorysRequest()),
      );
}
