import 'package:cambioseguro/models/coupon.dart';
import 'package:cambioseguro/models/preferential_rate.dart';

class Rate {
  final String id;
  final bool status;
  final double purchasePrice;
  final double salePrice;
  final double purchasePriceComparative;
  final double salePriceComparative;
  final bool complete;

  Rate({
    String id,
    bool status,
    double purchasePrice,
    double salePrice,
    double purchasePriceComparative,
    double salePriceComparative,
    this.complete = false,
  })  : this.id = id ?? '__',
        this.status = status ?? false,
        this.purchasePrice = purchasePrice ?? 0.0,
        this.salePrice = salePrice ?? 0.0,
        this.purchasePriceComparative = purchasePriceComparative ?? 0.0,
        this.salePriceComparative = salePriceComparative ?? 0.0;

  factory Rate.initState() => Rate(
        salePrice: 0,
        purchasePrice: 0,
        purchasePriceComparative: 0,
        salePriceComparative: 0,
        complete: false,
      );

  static Rate fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return Rate();

    return Rate(
      id: json['_id'],
      status: json['status'],
      purchasePrice: json['purchase_price'],
      salePrice: json['sale_price'],
      purchasePriceComparative: json['purchase_price_comparative'],
      salePriceComparative: json['sale_price_comparative'],
      complete: true,
    );
  }

  String purchasePriceFixed(
      {Coupon coupon, PreferentialRate preferentialRate}) {
    if (preferentialRate == null) return _getRateByPointsPurchase(coupon);
    return preferentialRate.rates.purchasePriceFixed();
  }

  String salePriceFixed({Coupon coupon, PreferentialRate preferentialRate}) {
    if (preferentialRate == null) return _getRateByPointsSale(coupon);
    return preferentialRate.rates.salePriceFixed();
  }

  String _getRateByPointsPurchase(Coupon coupon) {
    if (coupon == null) return purchasePrice.toStringAsFixed(4);
    int intPart = purchasePrice.toInt();
    double decimal = purchasePrice - intPart;
    double result = 0;
    result = (((intPart * 10000) + (decimal * 10000)) + coupon.purchasePoints) /
        10000;
    return result.toStringAsFixed(4);
  }

  String _getRateByPointsSale(Coupon coupon) {
    if (coupon == null) return salePrice.toStringAsFixed(4);
    int intPart = salePrice.toInt();
    double decimal = salePrice - intPart;
    double result = 0;
    result =
        (((intPart * 10000) + (decimal * 10000)) - coupon.salePoints) / 10000;
    return result.toStringAsFixed(4);
  }
}
