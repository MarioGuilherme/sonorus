import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/app_module.dart";
import "package:sonorus/src/app_widget.dart";
import "package:sonorus/src/core/env/env.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]),
    Env.instance.load()
  ]);
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}