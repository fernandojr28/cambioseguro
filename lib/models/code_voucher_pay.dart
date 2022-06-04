import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/bank_account.dart';

class CodeVoucherPay {
  final double realAmount;
  final double comission;
  final double totalAmount;
  final String code;
  final bool accountExist;
  final bool customerAccount;
  final bool operatorDeposit;
  final bool cci;
  final ChangeRequestStatus status;
  final String id;
  final double amount;
  final BankAccount bankAccount;

  CodeVoucherPay({
    this.realAmount = 0.0,
    this.comission = 0.0,
    this.totalAmount = 0.0,
    this.code = '',
    this.accountExist,
    this.customerAccount,
    this.operatorDeposit,
    this.cci,
    this.status,
    this.id,
    this.amount,
    BankAccount bankAccount,
  }) : this.bankAccount = bankAccount ?? BankAccount();
  static ChangeRequestStatus _getStatus(String status) {
    return ChangeRequestStatus.values.firstWhere(
        (e) => e.toString() == 'ChangeRequestStatus.$status',
        orElse: () => ChangeRequestStatus.pendiente);
  }

  static CodeVoucherPay initState(){
    return CodeVoucherPay(
      bankAccount: BankAccount.initState(),
    );
  }

  static CodeVoucherPay fromJson(dynamic json) {
    if (json == null) return CodeVoucherPay();

    return CodeVoucherPay(
      realAmount: json['real_amount'].toDouble(),
      comission: json['comission'].toDouble(),
      totalAmount: json['total_amount'].toDouble(),
      code: json['code'],
      accountExist: json['account_exist'],
      customerAccount: json['customer_account'],
      operatorDeposit: json['operator_deposit'],
      cci: json['cci'],
      status: _getStatus(json['status']),
      id: json['_id'],
      amount: json['amount'].toDouble(),
      bankAccount: BankAccount.fromJson(json['bank_account']),
    );
  }
}
