import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/models/change_request.dart';
import 'package:redux/redux.dart';

final changeRequestsReducer = combineReducers<List<ChangeRequest>>([
  TypedReducer<List<ChangeRequest>, LoadHistoryResponseAction>(_setData),
]);

List<ChangeRequest> _setData(
    List<ChangeRequest> requests, LoadHistoryResponseAction action) {
  List<ChangeRequest> _all = List<ChangeRequest>.from(requests);
  _all.removeWhere((t) => t.id == action.request.id);
  _all.add(action.request);

  return _all;
}
