import "package:flutter/material.dart";

class ColorsApp {
  static ColorsApp? _instance;

  ColorsApp._();

  static ColorsApp get instance {
    _instance ??= ColorsApp._();
    return _instance!;
  }

  // Color get secondary => const Color(0xFF561A2C);
  // Color get primary => const Color(0xFFB51A2B);
  // Color get tertiary => const Color(0xFFFFA586);
  // Color get quaternary => const Color(0xFF384358);
  // Color get quintennial => const Color(0xFF242E49);
  // Color get sextenary => const Color(0xFF171C2F);

  Color get primary => const Color(0XFFE11E46); // Antiga
  Color get secondary => const Color(0XFF16161F);
}

extension ColorsAppExtension on BuildContext {
  ColorsApp get colors => ColorsApp.instance;
}