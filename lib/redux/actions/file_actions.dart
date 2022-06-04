import 'dart:io';

import 'package:cambioseguro/enums/enum.dart';
import 'package:flutter/foundation.dart';

// class UploadPassportImageRequestAction {}

// class
class UploadPassportImageRequestAction {
  final Function(String) onSuccess;
  final ErrorCallback onError;
  final File file;

  UploadPassportImageRequestAction(
      {@required this.onSuccess, @required this.onError, @required this.file});
}

class UploadRequestImageRequestAction {
  final Function(String) onSuccess;
  final ErrorCallback onError;
  final File file;
  final int position;

  UploadRequestImageRequestAction(
      {@required this.onSuccess,
      @required this.onError,
      @required this.file,
      @required this.position});
}

class UploadBanksAccountsPassportAction {
  final File file;
  final Function(String) onSuccess;
  final ErrorCallback onError;

  UploadBanksAccountsPassportAction({
    @required this.onSuccess,
    @required this.onError,
    @required this.file,
  });
}
