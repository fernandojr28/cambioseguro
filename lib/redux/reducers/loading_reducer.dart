import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:redux/redux.dart';

final loadingReducer = combineReducers<bool>([
  TypedReducer<bool, LoadUserDataSuccessResponseAction>(_setLoading),
]);

bool _setLoading(bool isLoading, LoadUserDataSuccessResponseAction action) {
  return false;
}
