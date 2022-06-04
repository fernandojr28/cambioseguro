import 'dart:convert';
import 'dart:io';

import 'package:cambioseguro/abstract/abs.dart';
import 'package:cambioseguro/helpers/api_helpers.dart';
import 'package:cambioseguro/helpers/http_client.dart';
import 'package:cambioseguro/models/user_app.dart';
import 'package:cambioseguro/settings/settings.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class FileRepository implements FileRepositoryAbs {
  @override
  Future<String> uploadPassport(UserApp currentUser, File file) async {
    final http.Response res =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .post("${AppContants.endPoint}/client/post_upload_file_s3");
    checkResponseSuccess(res);
    final Map formData = jsonDecode(res.body);

    String url = formData['data']['url'];
    Map fields = formData['data']['fields'];
    var request = new http.MultipartRequest("POST", Uri.parse(url));
    fields.forEach((k, v) => request.fields[k] = v);
    request.files.add(
        new http.MultipartFile.fromBytes('file', await file.readAsBytes()));

    await request.send();

    return formData['url'];
  }

  @override
  Future<String> uploadRequestImage(
      UserApp currentUser, String requestId, File file, int position) async {
    final http.Response res =
        await ApiHttpClient(http.Client(), token: currentUser.token).post(
            "${AppContants.endPoint}/client/request/post_upload_file_s3/$requestId");
    checkResponseSuccess(res);
    try {
      final Map formData = jsonDecode(res.body);

      String url = formData['data']['url'];
      Map fields = formData['data']['fields'];
      var request = new http.MultipartRequest("POST", Uri.parse(url));
      fields.forEach((k, v) => request.fields[k] = v);
      request.files.add(
          new http.MultipartFile.fromBytes('file', await file.readAsBytes()));

      await request.send();

      return formData['url'];
    } catch (e) {
      print(e);
      throw PlatformException(
        message: 'Error al subir a s3',
        code: '500',
        details: e,
      );
    }
  }

  @override
  Future<String> uploadBakAccountPassport(
      UserApp currentUser, File file) async {
    final http.Response res =
        await ApiHttpClient(http.Client(), token: currentUser.token).post(
            "${AppContants.endPoint}/client/banks_accounts/post_upload_file_s3");
    checkResponseSuccess(res);
    try {
      final Map formData = jsonDecode(res.body);

      String url = formData['data']['url'];
      Map fields = formData['data']['fields'];
      var request = new http.MultipartRequest("POST", Uri.parse(url));
      fields.forEach((k, v) => request.fields[k] = v);
      request.files.add(
          new http.MultipartFile.fromBytes('file', await file.readAsBytes()));

      await request.send();

      return formData['url'];
    } catch (e) {
      print(e);
      throw PlatformException(
        message: 'Error al subir a s3',
        code: '500',
        details: e,
      );
    }
  }
}
