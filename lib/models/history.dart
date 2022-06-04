import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/shared/app_icons.dart';
import 'package:flutter/material.dart';

class History {
  final ChangeRequestStatus actualStatus;
  final String id;
  final String requestType;
  final double amountPaid;
  final double amountPayable;
  final DateTime createdAt;

  History({
    this.actualStatus,
    this.id,
    this.requestType,
    this.amountPaid,
    this.amountPayable,
    this.createdAt,
  });

  static ChangeRequestStatus _getStatus(String status) {
    return ChangeRequestStatus.values.firstWhere(
        (e) => e.toString() == 'ChangeRequestStatus.$status',
        orElse: () => ChangeRequestStatus.pendiente);
  }

  String titleStatus() {
    if (actualStatus == ChangeRequestStatus.rechazado)
      return '¡Operación rechazada!';
    if (actualStatus == ChangeRequestStatus.finalizado)
      return '¡Operación exitosa!';
    if (actualStatus == ChangeRequestStatus.cancelado)
      return '¡Operación cancelada!';

    return '';
  }

  static History fromJson(dynamic json) {
    if (json == null) return History();
    return History(
      actualStatus: _getStatus(json['actual_status']),
      id: json['_id'],
      requestType: json['request_type'],
      amountPaid: json['amount_paid'].toDouble(),
      amountPayable: json['amount_payable'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Color get cardColor => actualStatus == ChangeRequestStatus.finalizado
      ? Color(0XFF5433B5)
      : Color(0xFF707070);

  Color get titleColor => actualStatus == ChangeRequestStatus.finalizado
      ? Color(0xFF9CD000)
      : Colors.white;

  IconData get titleIcon => actualStatus == ChangeRequestStatus.finalizado
      ? AppIcons.requestSuccess
      : AppIcons.requestError;

  IconData get amountPaidIcon =>
      requestType == "compra" ? AppIcons.usd : AppIcons.pen;

  IconData get amountPayableIcon =>
      requestType == "compra" ? AppIcons.pen : AppIcons.usd;

  String get amountPayableIconText => requestType == "compra" ? "S/" : "\$";
  String get amountPayIconText => requestType == "compra" ? "\$" : "S/";
}
