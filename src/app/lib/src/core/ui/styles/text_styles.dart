import "package:flutter/material.dart";

class TextStyles {
  static TextStyles? _instance;

  TextStyles._();

  static TextStyles get instance {
    _instance ??= TextStyles._();
    return _instance!;
  }

  String get fontFamily => "MuseoModerno";
  String get monospaced => "RobotoMono";

  TextStyle get textBase => TextStyle(fontFamily: fontFamily, color: Colors.white);

  TextStyle get textThin => textBase.copyWith(fontWeight: FontWeight.w100);
  TextStyle get textExtraLight => textBase.copyWith(fontWeight: FontWeight.w200);
  TextStyle get textLight => textBase.copyWith(fontWeight: FontWeight.w300);
  TextStyle get textRegular => textBase.copyWith(fontWeight: FontWeight.normal);
  TextStyle get textMedium => textBase.copyWith(fontWeight: FontWeight.w500);
  TextStyle get textSemiBold => textBase.copyWith(fontWeight: FontWeight.w600);
  TextStyle get textBold => textBase.copyWith(fontWeight: FontWeight.w700);
  TextStyle get textExtraBold => textBase.copyWith(fontWeight: FontWeight.w800);
  TextStyle get textBlack => textBase.copyWith(fontWeight: FontWeight.w900);
  TextStyle get textMediumMono => TextStyle(fontWeight: FontWeight.w500, fontFamily: monospaced, color: Colors.white);
}

extension TextStylesExtension on BuildContext {
  TextStyles get textStyles => TextStyles.instance;
}