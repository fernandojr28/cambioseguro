import 'dart:io';

import 'package:cambioseguro/widgets/confirm_dialog_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> onShowConfirmDialog(BuildContext context) async {
  bool isConfirm = false;
  Widget body = ConfirmDialogBody(
    title: 'Cancelar operación',
    content: '¿Está seguro que desea cancelar esta operación?',
  );

  if (Platform.isIOS)
    isConfirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) => body,
    );
  else
    isConfirm = await showDialog(
      context: context,
      builder: (BuildContext context) => body,
    );
  return isConfirm == null ? false : isConfirm;
}
