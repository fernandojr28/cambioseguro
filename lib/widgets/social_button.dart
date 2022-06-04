import 'package:cambioseguro/shared/app_colors.dart';
import 'package:cambioseguro/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

enum SocialType { Facebook, Google }

class SocialButton extends CustomRaisedButton {
  SocialButton({
    Key key,
    Widget child,
    bool loading = false,
    Icon icon,
    SocialType type,
    VoidCallback onPressed,
  }) : super(
          key: key,
          child: child,
          // child: Text(
          //   text,
          //   style: TextStyle(color: Colors.white, fontSize: 20.0),
          // ),
          height: 44.0,
          color: type == SocialType.Facebook ? facebookColor : googleColor,
          textColor: Colors.black87,
          borderRadius: 8,
          loading: loading,
          onPressed: onPressed,
          icon: icon,
        );
}
