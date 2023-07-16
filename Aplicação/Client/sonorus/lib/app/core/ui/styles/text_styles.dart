import "package:flutter/material.dart";

class TextStyles {
  static TextStyles? _instance;

  TextStyles._();

  static TextStyles get instance {
    _instance ??= TextStyles._();
    return _instance!;
  }

  String get fontFamily => "futura";

  TextStyle get textLight => TextStyle(fontWeight: FontWeight.w300, fontFamily: fontFamily);
  TextStyle get textRegular => TextStyle(fontWeight: FontWeight.normal, fontFamily: fontFamily);
  TextStyle get textMedium => TextStyle(fontWeight: FontWeight.w500, fontFamily: fontFamily);
  TextStyle get textSemiBold => TextStyle(fontWeight: FontWeight.w600, fontFamily: fontFamily);
  TextStyle get textBold => TextStyle(fontWeight: FontWeight.bold, fontFamily: fontFamily);
}

extension TextStylesExtension on BuildContext {
  TextStyles get textStyles => TextStyles.instance;
}
