import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "package:sonorus/app/core/provider/application_binding.dart";
import "package:sonorus/app/core/ui/theme/theme_config.dart";
import "package:sonorus/app/pages/auth/login/login_router.dart";
import "package:sonorus/app/pages/auth/register/interests_router.dart";
import "package:sonorus/app/pages/auth/register/register_router.dart";
import "package:sonorus/app/pages/timeline/timeline_router.dart";

class SonorusApp extends StatelessWidget {
  const SonorusApp({super.key});

  @override
  Widget build(BuildContext context) {
     return ApplicationBinding(
      child: MaterialApp(
        debugShowCheckedModeBanner: kDebugMode,
        title: "Sonorus",
        theme: ThemeConfig.theme,
        initialRoute: "/login",
        routes: <String, Widget Function(BuildContext)>{
          "/login": (BuildContext context) => LoginRouter.page,
          "/register": (BuildContext context) => RegisterRouter.page,
          "/interests": (BuildContext context) => InterestsRouter.page,
          "/timeline": (BuildContext context) => TimelineRouter.page
        }
      )
    );
  }
}