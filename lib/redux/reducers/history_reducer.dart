import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/models/history.dart';
import 'package:redux/redux.dart';

final historyReducer = combineReducers<List<History>>([
  TypedReducer<List<History>, FetchHistoryResponse>(_setData),
]);

List<History> _setData(List<History> request, FetchHistoryResponse action) =>
    action.requests;
