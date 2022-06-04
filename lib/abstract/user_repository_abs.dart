import 'dart:async';

import 'package:cambioseguro/models/auth_data.dart';
import 'package:cambioseguro/models/user_app.dart';

abstract class UserRepositoryAbs {
  Future<UserApp> fetchUserData(UserApp currentUser);
  Future<UserApp> signInWithEmailAndPassword(AuthFormData authForm);
  Future<UserApp> signInWithGoogle();
  Future<UserApp> signInWithFacebook();
  Future<bool> sendEmailVerification(AuthFormData authForm);
  Future<UserApp> createUserWithEmailAndPassword(AuthFormData authForm);
  Future<bool> sendPasswordResetEmail(AuthFormData authForm);
  Future<bool> logout();
  Future<bool> changePassword(
      UserApp currentUser, String password, String password2);
}
