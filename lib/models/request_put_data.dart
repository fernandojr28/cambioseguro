import 'dart:collection';

import 'package:cambioseguro/extensions/string_extensions.dart';

class RequestPutData {
  // final String requestId;
  final bool cci;
  final String code;
  final double amount;
  final String image;

  RequestPutData({
    // this.requestId,
    this.cci,
    this.code,
    this.amount,
    this.image,
  });

  Map toJson() {
    Map _data = {
      "cci": cci,
      "code": code,
    };
    if (amount != null) _data['amount'] = amount;
    if (image != null) _data['image'] = image;
    return _data;
  }

  static RequestPutData fromJson(dynamic json) {
    final data = RequestPutData(
      image: json['image'],
      code: json['code'],
      cci: json['cci'],
      amount: json['amount'] != null ? '${json['amount']}'.parseDouble() : null,
    );

    return data;
  }

  List<RequestPutData> makeData(_fbKey) {
    Map values = _fbKey.currentState.value;
    Map<int, dynamic> submitList = HashMap();
    values.forEach((k, v) {
      List<String> obj = k.toString().split('-');
      int index = int.parse(obj[0]);
      String attribute = obj[1];
      var current = submitList[index] != null ? submitList[index] : {};
      submitList[index] = {
        ...current,
        ...{'$attribute': '$v', 'cci': cci}
      };
    });
    List<RequestPutData> requestPutData = [];
    submitList.forEach((k, v) {
      requestPutData.add(RequestPutData.fromJson(v));
    });
    return requestPutData;
  }
}
