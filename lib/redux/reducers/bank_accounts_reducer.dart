import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/models/bank_account.dart';
import 'package:redux/redux.dart';

final bankAccountsReducer = combineReducers<List<BankAccount>>([
  TypedReducer<List<BankAccount>, LoadBanksAccountsResponseAction>(_reducer),
  TypedReducer<List<BankAccount>, DeleteBankAccountRequestAction>(
      _deleteBankAccount),
]);

List<BankAccount> _reducer(_, LoadBanksAccountsResponseAction action) {
  return action.bankAccounts;
}

List<BankAccount> _deleteBankAccount(
    List<BankAccount> bankAccounts, DeleteBankAccountRequestAction action) {
  List<BankAccount> accounts = List.from(bankAccounts);
  int index = accounts.indexWhere((t) => t.id == action.id);
  BankAccount _oldAcoount = accounts[index];
  accounts.removeAt(index);
  accounts.insert(index, _oldAcoount.copyWith(busy: true));

  return accounts;
}
