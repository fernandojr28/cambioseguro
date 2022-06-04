import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/account_cs.dart';
import 'package:cambioseguro/models/code_voucher.dart';
import 'package:cambioseguro/models/code_voucher_pay.dart';
import 'package:cambioseguro/models/message.dart';
import 'package:cambioseguro/models/rate.dart';
import 'package:cambioseguro/shared/app_icons.dart';
import 'package:flutter/material.dart';

class ChangeRequest {
  final String actualStatus;
  final bool preferential;
  final bool hasCoupon;
  final String id;
  final String codeRequest;
  final String requestType;
  final double amountPaid;
  final double amountPayable;
  final String transferCode;
  final ChangeRequestStatus status;
  final Rate rate;
  final AccountCs accountCs;
  final List<Message> messages;
  final CodeVoucherPay codeVoucherPay;
  final CodeVoucher codeVoucher;
  final int time;
  final bool isComplete;
  final bool pageRefresh;

  ChangeRequest({
    this.isComplete = false,
    this.pageRefresh = false,
    this.actualStatus,
    this.preferential,
    this.hasCoupon,
    this.id,
    this.codeRequest,
    this.requestType,
    this.amountPaid,
    this.amountPayable,
    this.status,
    Rate rate,
    this.accountCs,
    this.messages,
    String transferCode,
    CodeVoucherPay codeVoucherPay,
    CodeVoucher codeVoucher,
    int time,
  })  : this.transferCode = transferCode ?? '',
        this.codeVoucherPay = codeVoucherPay ?? CodeVoucherPay.initState(),
        this.codeVoucher = codeVoucher ?? CodeVoucher.initState(),
        this.rate = rate ?? Rate.initState(),
        this.time = time ?? 0;

  ChangeRequest copyWith({
    bool isCci,
    String actualStatus,
    bool preferential,
    bool hasCoupon,
    String id,
    String codeRequest,
    String requestType,
    double amountPaid,
    double amountPayable,
    ChangeRequestStatus status,
    Rate rate,
    AccountCs accountCs,
    List<Message> messages,
    String transferCode,
    CodeVoucherPay codeVoucherPay,
    CodeVoucher codeVoucher,
    int time,
    bool isComplete,
  }) =>
      ChangeRequest(
        actualStatus: actualStatus ?? this.actualStatus,
        preferential: preferential ?? this.preferential,
        hasCoupon: hasCoupon ?? this.hasCoupon,
        id: id ?? this.id,
        codeRequest: codeRequest ?? this.codeRequest,
        requestType: requestType ?? this.requestType,
        amountPaid: amountPaid ?? this.amountPaid,
        amountPayable: amountPayable ?? this.amountPayable,
        status: status ?? this.status,
        rate: rate ?? this.rate,
        accountCs: accountCs ?? this.accountCs,
        messages: messages ?? this.messages,
        transferCode: transferCode ?? this.transferCode,
        codeVoucherPay: codeVoucherPay ?? this.codeVoucherPay,
        codeVoucher: codeVoucher ?? this.codeVoucher,
        time: time ?? this.time,
        isComplete: isComplete ?? this.isComplete,
      );

  static ChangeRequestStatus _getStatus(String status) {
    return ChangeRequestStatus.values.firstWhere((e) =>
        e.toString() == 'ChangeRequestStatus.${status.trim().toLowerCase()}');
  }

  static ChangeRequest fromJsonStatus(dynamic json) {
    if (json == null) return ChangeRequest();
    return ChangeRequest(status: _getStatus(json['status']));
  }

  static ChangeRequest fromJson(dynamic json) {
    if (json == null) return ChangeRequest();
    return ChangeRequest(
      isComplete: true,
      actualStatus: json['actual_status'],
      preferential: json['preferential'],
      hasCoupon: json['has_coupon'],
      id: json['_id'],
      codeRequest: json['code_request'],
      requestType: json['request_type'],
      amountPaid: json['amount_paid'].toDouble(),
      amountPayable: json['amount_payable'].toDouble(),
      transferCode: json['transfer_code'],
      time: json['time'],
      status: _getStatus(json['actual_status']),
      rate: Rate.fromJson(json['rates']),
      accountCs: AccountCs.fromJson(json['account_cs']),
      messages: json['message'] == null
          ? []
          : (json['message'] as List).map((m) => Message.fromJson(m)).toList(),
      codeVoucherPay: (json['codes_vouchers_pay'] != null)
          ? CodeVoucherPay.fromJson((json['codes_vouchers_pay'] as List)[0])
          : null,
      codeVoucher: (json['codes_vouchers'] != null)
          ? CodeVoucher.fromJson((json['codes_vouchers'] as List)[0])
          : null,
    );
  }

  String titleStatus() {
    if (status == ChangeRequestStatus.rechazado) return '¡Operación rechazada!';
    if (status == ChangeRequestStatus.finalizado) return '¡Operación exitosa!';
    if (status == ChangeRequestStatus.cancelado) return '¡Operación cancelada!';
    if (status == ChangeRequestStatus.pendiente) return '¡Operación pendiente!';
    return "";
  }

  String get amountPayableFixed2 => amountPayable.toStringAsFixed(2);

  String get amountPaidFixed2 => amountPaid.toStringAsFixed(2);

  Color get cardColor => status == ChangeRequestStatus.finalizado
      ? Color(0xFF9CD000)
      : Color(0xFF707070);

  Color get titleColor => status == ChangeRequestStatus.finalizado
      ? Color(0xFF9CD000)
      : Colors.black;

  IconData get titleIcon => status == ChangeRequestStatus.finalizado
      ? AppIcons.requestSuccess
      : AppIcons.requestError;

  IconData get amountPaidIcon =>
      requestType == "compra" ? AppIcons.usd : AppIcons.pen;

  IconData get amountPayableIcon =>
      requestType == "compra" ? AppIcons.pen : AppIcons.usd;

  String get amountPayableIconText => requestType == "compra" ? "S/" : "\$";
  String get amountPaidIconText => requestType == "compra" ? "\$" : "S/";
}
