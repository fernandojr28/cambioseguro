import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/models/bank.dart';
import 'package:redux/redux.dart';

final banksReducer = combineReducers<List<Bank>>([
  TypedReducer<List<Bank>, LoadBanksResponseAction>(_activeTabReducer),
]);

List<Bank> _activeTabReducer(
    List<Bank> ubigeos, LoadBanksResponseAction action) {
  return action.banks;
}
