import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/bank_account.dart';
import 'package:cambioseguro/models/change_request.dart';
import 'package:cambioseguro/selectors/optional.dart';

bool isLoggedIn(AppState state) => state.currentUser != null;

Optional<ChangeRequest> requestSelector(
    List<ChangeRequest> requests, String requestId) {
  try {
    return Optional.of(requests.firstWhere((t) => t.id == requestId,
        orElse: () => ChangeRequest()));
  } catch (e) {
    return Optional.absent();
  }
}

Optional<BankAccount> bankAccountSelector(
    List<BankAccount> requests, String id) {
  try {
    return Optional.of(
        requests.firstWhere((t) => t.id == id, orElse: () => BankAccount()));
  } catch (e) {
    return Optional.absent();
  }
}
