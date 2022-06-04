import 'package:flutter/widgets.dart';

//http://fontello.com/
class AppIcons {
  static const IconData user = const IconDataBrands(0xE814);
  static const IconData lock = const IconDataBrands(0xe816);
  static const IconData lockAlt = const IconDataBrands(0xE825);
  static const IconData business = const IconDataBrands(0xE826);
  static const IconData plusCircle = const IconDataBrands(0xE80A);
  static const IconData at = const IconDataBrands(0xE827);
  static const IconData requestSuccess = const IconDataBrands(0xE80D);
  static const IconData requestError = const IconDataBrands(0xE809);
  static const IconData usd = const IconDataBrands(0xE830);
  static const IconData pen = const IconDataBrands(0xE831);
  static const IconData ticket = const IconDataBrands(0xE810);
  static const IconData inbox = const IconDataBrands(0xE820);
}

class IconDataBrands extends IconData {
  const IconDataBrands(int codePoint)
      : super(
          codePoint,
          fontFamily: 'AppIcons',
          // fontPackage: 'font_awesome_flutter',
        );
}
