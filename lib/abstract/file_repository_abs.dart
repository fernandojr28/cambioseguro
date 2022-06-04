import 'dart:io';

import 'package:cambioseguro/models/user_app.dart';

abstract class FileRepositoryAbs {
  Future<String> uploadPassport(UserApp currentUser, File file);
  Future<String> uploadRequestImage(
      UserApp currentUser, String requestId, File file, int position);
  Future<String> uploadBakAccountPassport(UserApp currentUser, File file);
}
