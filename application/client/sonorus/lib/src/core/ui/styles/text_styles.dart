import "package:flutter/material.dart";

class TextStyles {
  static TextStyles? _instance;

  TextStyles._();

  static TextStyles get instance {
    _instance ??= TextStyles._();
    return _instance!;
  }

  String get fontFamily => "MuseoModerno";

  TextStyle get textThin => TextStyle(fontWeight: FontWeight.w100, fontFamily: fontFamily);
  TextStyle get textExtraLight => TextStyle(fontWeight: FontWeight.w200, fontFamily: fontFamily);
  TextStyle get textLight => TextStyle(fontWeight: FontWeight.w300, fontFamily: fontFamily);
  TextStyle get textRegular => TextStyle(fontWeight: FontWeight.normal, fontFamily: fontFamily);
  TextStyle get textMedium => TextStyle(fontWeight: FontWeight.w500, fontFamily: fontFamily);
  TextStyle get textSemiBold => TextStyle(fontWeight: FontWeight.w600, fontFamily: fontFamily);
  TextStyle get textBold => TextStyle(fontWeight: FontWeight.w700, fontFamily: fontFamily);
  TextStyle get textExtraBold => TextStyle(fontWeight: FontWeight.w800, fontFamily: fontFamily);
  TextStyle get textBlack => TextStyle(fontWeight: FontWeight.w900, fontFamily: fontFamily);
  TextStyle get textMediumMono => TextStyle(fontWeight: FontWeight.w500, fontFamily: fontFamily);
}

extension TextStylesExtension on BuildContext {
  TextStyles get textStyles => TextStyles.instance;
}