import 'package:cambioseguro/shared/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static get theme {
    return ThemeData(
      primaryColor: primaryColor,
      primaryColorLight: Color(0xFF6E46E6),
      secondaryHeaderColor: Color(0xFF06F482),
      // accentColor: Color(0xFF6E46E6),
      // unselectedWidgetColor: primaryColor,
      iconTheme: new IconThemeData(
        color: Colors.grey[700],
      ),
      // backgroundColor: Colors.red,
      bottomAppBarColor: Colors.grey[800],
      scaffoldBackgroundColor: Colors.white,
      buttonTheme: ButtonThemeData(
        highlightColor: Colors.transparent
      ),
      applyElevationOverlayColor: false,
      // buttonTheme: ButtonThemeData(
      // shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.all(Radius.circular(50.0)),
      //             ),
                  
      // ),
      
    );
  }
}
