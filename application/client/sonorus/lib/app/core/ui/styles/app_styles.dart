import "package:flutter/material.dart";

import "package:sonorus/app/core/ui/styles/colors_app.dart";
import "package:sonorus/app/core/ui/styles/text_styles.dart";

class AppStyles {
  static AppStyles? _instance;

  AppStyles._();

  static AppStyles get instance {
    _instance ??= AppStyles._();
    return _instance!;
  }

  ButtonStyle get primaryButton => ElevatedButton.styleFrom(
    textStyle: TextStyles.instance.textBold.copyWith(fontSize: 18),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(vertical: 10),
    backgroundColor: ColorsApp.instance.primary
  );

  ButtonStyle get primaryOutlineButton => OutlinedButton.styleFrom(
    textStyle: TextStyles.instance.textBold.copyWith(fontSize: 18, color: ColorsApp.instance.primary),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(vertical: 10),
    side: BorderSide(width: 1, color: ColorsApp.instance.primary),
  );
}

extension AppStylesExtension on BuildContext {
  AppStyles get appStyles => AppStyles.instance;
}