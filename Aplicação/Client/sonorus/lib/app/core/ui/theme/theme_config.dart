import "package:flutter/material.dart";

import "package:sonorus/app/core/ui/styles/app_styles.dart";
import "package:sonorus/app/core/ui/styles/colors_app.dart";
import "package:sonorus/app/core/ui/styles/text_styles.dart";

class ThemeConfig {
  ThemeConfig._();

  static final _defaultInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide.none
  );

  static final theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsApp.instance.primary,
      primary: ColorsApp.instance.primary,
      secondary: ColorsApp.instance.secondary
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: AppStyles.instance.primaryButton),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color.fromRGBO(255, 255, 255, .15),
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.all(13),
      border: ThemeConfig._defaultInputBorder,
      enabledBorder: ThemeConfig._defaultInputBorder,
      focusedBorder: ThemeConfig._defaultInputBorder,
      labelStyle: TextStyles.instance.textMedium.copyWith(color: Colors.white),
      errorStyle: TextStyles.instance.textRegular.copyWith(color: Colors.redAccent)
    )
  );
}