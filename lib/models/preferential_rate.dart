import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/rate.dart';

class PreferentialRate {
  final RequestType requestType;
  final double amountPayable;
  final double rate;
  final double total;
  final int time;
  final Rate rates;

  PreferentialRate({
    this.requestType,
    this.amountPayable,
    this.rate,
    this.total,
    this.time,
    this.rates,
  });

  static PreferentialRate fromJson(dynamic json) {
    if (json == null || json == '') PreferentialRate();
    return PreferentialRate(
      requestType: RequestType.values.firstWhere(
          (e) => e.toString() == 'RequestType.${json['type']}',
          orElse: () => RequestType.compra),
      amountPayable: json['amount_payable'].toDouble(),
      rate: json['rate'].toDouble(),
      total: json['total'].toDouble(),
      time: json['time'],
      rates: Rate.fromJson(json['rates']),
    );
  }

  String get rateToFixed => rate.toStringAsFixed(4);
  String get amountPayableFixed => amountPayable.toStringAsFixed(2);
  String get totalFixed => total.toStringAsFixed(2);
}
