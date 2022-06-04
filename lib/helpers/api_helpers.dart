import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void checkResponseSuccess(http.Response response) {
  _hashError(response);
  if (response.statusCode == 200) return;

  var message = "";
  try {
    Map json = jsonDecode(response.body);
    message = json['message'];
  } catch (e) {
    message = response.body;
  }
  throw PlatformException(
      code: "${response.statusCode}",
      message: "$message",
      details: response.body);
}

void _hashError(http.Response response) {
  Map data = HashMap();
  var message = "";
  try {
    data = jsonDecode(response.body);
    Map json = jsonDecode(response.body);
    message = json['message'];
  } catch (e) {
    message = response.body;
  }
  if (data.containsKey('error')) {
    bool _isError = data['error'] as bool;

    /// Not have error
    if (!_isError) return;
  }

  if (data.containsKey('slug'))
    throw PlatformException(
        code: "${response.statusCode}",
        message: "$message",
        details: response.body);

  if (data.containsKey('input')) {
    Map input = data['input'];
    String key = input.keys.first;
    if (input[key] is String)
      message = input['name'].toString();
    else
      message = input[key]['name'].toString();
    throw PlatformException(
        code: "${response.statusCode}",
        message: "$message",
        details: response.body);
  }
  // throw PlatformException(
  //     code: "${response.statusCode}",
  //     message: "$message",
  //     details: response.body);
}
