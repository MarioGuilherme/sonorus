import "package:flutter/material.dart";

import "package:sonorus/app/core/provider/application_binding.dart";
import "package:sonorus/app/core/ui/theme/theme_config.dart";
import "package:sonorus/app/pages/auth/login_router.dart";
import "package:sonorus/app/pages/timeline/timeline_router.dart";

class SonorusApp extends StatelessWidget {
  const SonorusApp({super.key});

  @override
  Widget build(BuildContext context) {
     return ApplicationBinding(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Sonorus",
        theme: ThemeConfig.theme,
        initialRoute: "/login",
        routes: <String, Widget Function(BuildContext)>{
          "/login": (BuildContext context) => LoginRouter.page,
          "/timeline": (BuildContext context) => TimelineRouter.page
        }
      )
    );
  }
}