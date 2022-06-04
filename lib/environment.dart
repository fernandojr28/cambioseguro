import 'package:cambioseguro/abstract/abs.dart';
import 'package:cambioseguro/redux/store.dart';
import 'package:flutter/services.dart';

class Environment {
  static setup(
    UserRepositoryAbs userRepository,
    AppRepositoryAbs appRepository,
    FileRepositoryAbs fileRepository,
  ) async{
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp, DeviceOrientation.portraitDown
      ]);
      return await createStore(userRepository, appRepository, fileRepository);
  }
}
