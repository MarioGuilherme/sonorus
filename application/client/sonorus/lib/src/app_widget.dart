import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:sonorus/src/core/ui/theme/theme_config.dart";

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute("/login");
    return ScreenUtilInit(
      child: MaterialApp.router(
        title: "Sonorus",
        theme: ThemeConfig.theme,
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate
      )
    );
  }
}