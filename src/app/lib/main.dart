import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";

import "package:sonorus/src/app_module.dart";
import "package:sonorus/src/app_widget.dart";
import "package:sonorus/src/core/env/env.dart";

void main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.wait([
    SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]),
    Env.instance.load()
  ]);
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}