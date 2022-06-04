import 'package:cambioseguro/keys.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: AppKeys.logoText,
      child: Image.asset(
        'assets/img/logo_text.png',
        height: 50,
      ),
    );
  }
}
