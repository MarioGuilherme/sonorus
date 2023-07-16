import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:sonorus/app/core/env/env.dart";
import "package:sonorus/app/sonorus_app.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]);
  await Env.instance.load();
  runApp(const SonorusApp());
}