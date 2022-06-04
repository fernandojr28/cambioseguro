import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/change_request.dart';
import 'package:cambioseguro/selectors/selectors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cambioseguro/redux/actions/actions.dart';

class HistoryDetailContainer extends StatelessWidget {
  final Function(BuildContext context, _ViewModel vm) builder;
  final String historyId;

  const HistoryDetailContainer(
      {Key key, @required this.builder, @required this.historyId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(store, historyId),
      builder: builder,
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.onLoadHistory,
    @required this.changeHistory,
  });

  final VoidCallback onLoadHistory;
  final ChangeRequest changeHistory;

  static _ViewModel fromStore(Store<AppState> store, String historyId) {
    final ChangeRequest request =
        requestSelector(store.state.changeRequests, historyId).value;
    return _ViewModel(
      changeHistory: request,
      onLoadHistory: () => store.dispatch(LoadHistoryRequestAction(historyId)),
    );
  }
}
