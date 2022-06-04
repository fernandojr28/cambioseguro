import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:redux/redux.dart';

final tabsReducer = combineReducers<int>([
  TypedReducer<int, UpdateTabAction>(_activeTabReducer),
]);

int _activeTabReducer(int activeTab, UpdateTabAction action) {
  return action.newTab;
}
