import 'dart:convert';
import 'dart:io';

import 'package:device_id/device_id.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:http/http.dart';

class ApiHttpClient extends BaseClient {
  ApiHttpClient(this._inner, {this.token, this.headers});

  final Client _inner;

  final String token;
  final Map<String, String> headers;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    request.headers[HttpHeaders.userAgentHeader] =
        await FlutterUserAgent.getPropertyAsync('userAgent');
    request.headers[HttpHeaders.contentTypeHeader] = "application/json";

    String deviceId = await DeviceId.getID;
    request.headers['device'] = base64.encode(utf8.encode(
        jsonEncode({"device_id": deviceId, "type": Platform.operatingSystem})));

    if (headers != null)
      headers.forEach((k, v) {
        request.headers[k] = v;
      });

    if (token != null)
      request.headers[HttpHeaders.authorizationHeader] = "Bearer $token";

    return _inner.send(request);
  }
}
