import 'package:cambioseguro/presentation/home/account/account_form.dart';
import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/request_data.dart';
import 'package:cambioseguro/models/user_app.dart';
import 'package:flutter/material.dart';

class UserDataScreen extends StatelessWidget {
  const UserDataScreen({
    Key key,
    @required this.currentUser,
    @required this.onRequestChange,
    @required this.requestData,
  }) : super(key: key);

  final UserApp currentUser;
  final Function(RequestData, VoidCallback, ErrorCallback) onRequestChange;
  final RequestData requestData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completa tus datos personales'),
      ),
      body: AccountForm(
        currentUser: currentUser,
        // onRequestChange: onRequestChange,
        requestData: requestData,
      ),
    );
  }
}
