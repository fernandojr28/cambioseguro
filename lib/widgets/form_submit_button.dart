import 'package:cambioseguro/shared/app_colors.dart';
import 'package:cambioseguro/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    Key key,
    @required Widget child,
    Color textColor = Colors.black87,
    Color color = buttonColor,
    bool loading = false,
    VoidCallback onPressed,
  }) : super(
          key: key,
          child: child,
          height: 44.0,
          color: color ?? buttonColor,
          textColor: textColor ?? Colors.black87,
          borderRadius: 8,
          loading: loading,
          onPressed: onPressed,
        );
}
