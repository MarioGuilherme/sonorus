import "package:flutter/material.dart";

import "package:sonorus/src/core/ui/styles/app_styles.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";

class ThemeConfig {
  ThemeConfig._();

  static final _defaultInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide.none
  );

  static final theme = ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: ColorsApp.instance.primary, iconTheme: IconThemeData(color: Colors.white)),
    dialogTheme: DialogThemeData(backgroundColor: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white)
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsApp.instance.primary,
      primary: ColorsApp.instance.primary,
      secondary: ColorsApp.instance.secondary
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: AppStyles.instance.primaryButton),
    outlinedButtonTheme: OutlinedButtonThemeData(style: AppStyles.instance.primaryOutlineButton),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color.fromRGBO(255, 255, 255, .15),
      filled: true,
      contentPadding: const EdgeInsets.all(8),
      border: ThemeConfig._defaultInputBorder,
      enabledBorder: ThemeConfig._defaultInputBorder,
      focusedBorder: ThemeConfig._defaultInputBorder,
      prefixIconColor: Colors.white,
      suffixIconColor: Colors.white,
      labelStyle: TextStyles.instance.textMedium.copyWith(color: Colors.white, fontSize: 16),
      errorStyle: TextStyles.instance.textRegular.copyWith(color: const Color(0xFFFE2651), fontSize: 14),
      errorMaxLines: 20
    )
  );
}