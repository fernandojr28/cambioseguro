import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/models/change_request.dart';
import 'package:redux/redux.dart';

final changeRequestReducer = combineReducers<ChangeRequest>([
  TypedReducer<ChangeRequest, RequestChangeResponseAction>(_setData),
  TypedReducer<ChangeRequest, RequestChangeDeleteResponseAction>(_cleanData),
  TypedReducer<ChangeRequest, RequestChangeStreamAction>(_updateStatus),
]);

ChangeRequest _setData(
        ChangeRequest request, RequestChangeResponseAction action) =>
    action.request;

ChangeRequest _updateStatus(
        ChangeRequest request, RequestChangeStreamAction action) =>
    request.copyWith(status: action.request.status);

ChangeRequest _cleanData(
        ChangeRequest request, RequestChangeDeleteResponseAction action) =>
    null;
