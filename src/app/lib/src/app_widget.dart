import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:sonorus/src/core/ui/theme/theme_config.dart";

class AppWidget extends StatelessWidget {
  const AppWidget({ super.key });
  
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    Modular.setInitialRoute("/login/");
    return ScreenUtilInit(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: "Sonorus",
        theme: ThemeConfig.theme,
        routerConfig: Modular.routerConfig
      )
    );
  }
}