import 'dart:convert';
import 'package:cambioseguro/abstract/user_repository_abs.dart';
import 'package:cambioseguro/helpers/api_helpers.dart';
import 'package:cambioseguro/helpers/http_client.dart';
import 'package:cambioseguro/models/auth_data.dart';
import 'package:cambioseguro/models/user_app.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:cambioseguro/settings/settings.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
final facebookLogin = FacebookLogin();

class UserRepository implements UserRepositoryAbs {
  @override
  Future<UserApp> fetchUserData(UserApp currentUser) async {
    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .get("${AppContants.endPoint}/client");

    checkResponseSuccess(response);
    Map json = jsonDecode(response.body);
    Map data = json['data'];
    var current = UserApp.fromJson(data);
    return current.copyWith(
      token: currentUser.token,
      hasData: json['has_data'],
      isValidated: json['is_validated'],
    );
  }

  @override
  Future<UserApp> createUserWithEmailAndPassword(AuthFormData authForm) async {
    http.Response response = await ApiHttpClient(http.Client()).post(
        "${AppContants.endPoint}/client/",
        body: jsonEncode(authForm.toJson()));

    checkResponseSuccess(response);
    return UserApp.fromJson(jsonDecode(response.body));
  }

  @override
  Future<bool> sendEmailVerification(AuthFormData authForm) async {
    return null;
  }

  @override
  Future<bool> sendPasswordResetEmail(AuthFormData authForm) async {
    String _body = jsonEncode(authForm.toJson());
    http.Response response = await ApiHttpClient(http.Client())
        .post("${AppContants.endPoint}/client/recover_password", body: _body);
    checkResponseSuccess(response);
    return Future.value(true);
  }

  @override
  Future<UserApp> signInWithEmailAndPassword(AuthFormData authForm) async {
    http.Response response = await ApiHttpClient(http.Client()).post(
        "${AppContants.endPoint}/client/auth/login",
        body: jsonEncode(authForm.toJson()));
    checkResponseSuccess(response);
    return UserApp.fromJson(jsonDecode(response.body));
  }

  @override
  Future<bool> logout() async {
    await ApiHttpClient(http.Client())
        .post("${AppContants.endPoint}/client/auth/logout");

    return Future.value(true);
  }

  @override
  Future<UserApp> signInWithGoogle() async {
    GoogleSignInAccount user = await _googleSignIn.signIn();
    GoogleSignInAuthentication auth = await user.authentication;
    http.Response response = await ApiHttpClient(http.Client())
        .post("${AppContants.endPoint}/auth/google",
            body: jsonEncode({
              "code": auth.accessToken,
            }));
    checkResponseSuccess(response);
    Map data = jsonDecode(response.body);
    return UserApp.fromJson(data);
  }

  @override
  Future<UserApp> signInWithFacebook() async {
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        http.Response response = await ApiHttpClient(http.Client()).post(
            "${AppContants.endPoint}/auth/facebook",
            body: jsonEncode({'code': result.accessToken.token}));

        checkResponseSuccess(response);
        Map data = jsonDecode(response.body);
        return UserApp.fromJson(data);
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        throw new PlatformException(
            code: "500", message: result.errorMessage, details: result);
        break;
    }
    return null;
  }

  @override
  Future<bool> changePassword(
      UserApp currentUser, String password, String password2) async {
    String _body = jsonEncode({"password": password, "password2": password2});
    http.Response response =
        await ApiHttpClient(http.Client(), token: currentUser.token)
            .put("${AppContants.endPoint}/client/change_password", body: _body);
    checkResponseSuccess(response);
    final res = jsonDecode(response.body);
    return res['error'] as bool;
  }
}
