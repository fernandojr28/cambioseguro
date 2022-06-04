import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cambioseguro/models/bank_account.dart';

part 'request_data.freezed.dart';

@freezed
abstract class RequestData with _$RequestData {
  factory RequestData({
    double amountPaid,
    BankAccount bankAccountOrigin,
    BankAccount bankAccount,
    RequestType requestType,
    PreferentialRate preferentialRate,
    Rate rate,
    Coupon currentCoupon,
    double penAmount,
    ConfigRequest config,
    bool onEditAmount,
  }) = _RequestData;

  @late
  bool get isCSPurchase => requestType == RequestType.compra;

  @late
  RequestType get makeRequestType => preferentialRate == null
      ? !isCSPurchase ? RequestType.venta : RequestType.compra
      : preferentialRate.requestType;

  @late
  String get makeRequestTypeText =>
      requestType == RequestType.venta ? 'venta' : 'compra';

  @late
  bool get isActiveUserChangeRequestType => preferentialRate == null;

  @late
  bool get onEditAmountT => onEditAmount ?? false;

  @late
  String get amountPayableMin => onEditAmountT
      ? penAmount.toStringAsFixed(2)
      : preferentialRate != null
          ? preferentialRate.amountPayable.toStringAsFixed(2)
          : config.requestAmountMinSFixed;

  @late
  String get calcPENtoUSD => preferentialRate != null
      ? preferentialRate.totalFixed
      : (penAmount /
              (double.parse(rate.salePriceFixed(
                  coupon: currentCoupon, preferentialRate: preferentialRate))))
          .toStringAsFixed(2);

  @late
  bool get isComplete => rate != null && config != null && penAmount != null;

  @late
  String get calcUSDtoPEN => preferentialRate != null
      ? preferentialRate.totalFixed
      : (penAmount *
              (double.parse(rate.purchasePriceFixed(
                  coupon: currentCoupon, preferentialRate: preferentialRate))))
          .toStringAsFixed(2);

  @late
  String get amountPayableTotal =>
      requestType == RequestType.venta ? calcPENtoUSD : calcUSDtoPEN;

  @late
  Map get toMap => {
        "amount_paid": penAmount,
        "amount_payable": amountPayableTotal,
        "bank_account_origin": bankAccountOrigin?.id,
        "id_bank_account": bankAccount?.id,
        "id_rate": rate.id,
        "preferential": preferentialRate != null,
        "rates": isCSPurchase
            ? double.parse(rate.purchasePriceFixed(coupon: currentCoupon))
            : double.parse(rate.salePriceFixed(coupon: currentCoupon)),
        "request_type": makeRequestTypeText,
      };
}
