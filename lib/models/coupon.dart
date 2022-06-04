class Coupon {
  final String id;
  final double purchasePoints;
  final double salePoints;
  final int minCompra;
  final int minVenta;
  final int maxCompra;
  final int maxVenta;

  Coupon({
    String id,
    double purchasePoints,
    double salePoints,
    int minCompra,
    int minVenta,
    int maxCompra,
    int maxVenta,
  })  : this.id = id ?? '',
        this.purchasePoints = purchasePoints ?? 0,
        this.salePoints = salePoints ?? 0,
        this.minCompra = minCompra ?? 0,
        this.minVenta = minVenta ?? 0,
        this.maxCompra = maxCompra ?? 0,
        this.maxVenta = maxVenta ?? 0;

  static Coupon fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return Coupon();
    return Coupon(
      id: json['_id'],
      purchasePoints: json['purchase_points'].toDouble(),
      salePoints: json['sale_points'].toDouble(),
      minCompra: json['min_compra'],
      minVenta: json['min_venta'],
      maxCompra: json['max_compra'],
      maxVenta: json['max_venta'],
    );
  }
}
