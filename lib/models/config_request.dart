class ConfigRequest {
  final String id;
  final int operationTime;
  final double vipRequestAmountS;
  final double vipRequestAmountD;
  final int additionalTimeVip;
  final int rateTime;
  final double requestAmountMinS;
  final double requestAmountMinD;

  ConfigRequest({
    this.id,
    this.operationTime,
    this.vipRequestAmountS,
    this.vipRequestAmountD,
    this.additionalTimeVip,
    this.rateTime,
    this.requestAmountMinS,
    this.requestAmountMinD,
  });

  factory ConfigRequest.init() {
    return ConfigRequest(
      id: "___",
      vipRequestAmountD: 0.0,
      additionalTimeVip: 0,
      operationTime: 0,
      rateTime: 0,
      requestAmountMinD: 0.0,
      requestAmountMinS: 0.0,
      vipRequestAmountS: 0.0,
    );
  }

  static ConfigRequest fomJson(dynamic json) {
    if (json == null) return ConfigRequest();
    return ConfigRequest(
      id: json['_id'],
      operationTime: json['operation_time'],
      vipRequestAmountS: json['vip_request_amount_s'].toDouble(),
      vipRequestAmountD: json['vip_request_amount_d'].toDouble(),
      additionalTimeVip: json['additional_time_vip'],
      rateTime: json['rate_time'],
      requestAmountMinS: json['request_amount_min_s'].toDouble(),
      requestAmountMinD: json['request_amount_min_d'].toDouble(),
    );
  }

  String get requestAmountMinSFixed => requestAmountMinS.toStringAsFixed(2);
  String get requestAmountMinDFixed => requestAmountMinD.toStringAsFixed(2);
}
