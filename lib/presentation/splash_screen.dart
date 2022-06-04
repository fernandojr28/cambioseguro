import 'package:cambioseguro/widgets/app_logo.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 20,
            right: -150,
            child: Image.asset('assets/img/arrow_left.png'),
          ),
          Align(
            alignment: Alignment.center,
            child: AppLogo(),
          ),
          Positioned(
            bottom: 30,
            left: -150,
            child: Image.asset('assets/img/arrow_right.png'),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: Text(
                '\u00a9 2019 Cambio Seguro',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }
}
