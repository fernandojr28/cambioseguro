import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/models/ubigeo.dart';
import 'package:redux/redux.dart';

final ubigeosReducer = combineReducers<List<Ubigeo>>([
  TypedReducer<List<Ubigeo>, LoadUbigeoResponseAction>(_activeTabReducer),
]);

List<Ubigeo> _activeTabReducer(
    List<Ubigeo> ubigeos, LoadUbigeoResponseAction action) {
  return action.ubigeos;
}
