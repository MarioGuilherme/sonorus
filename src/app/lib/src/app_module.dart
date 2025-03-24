import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/core_module.dart";
import "package:sonorus/src/modules/chat_realtime/chat_realtime_module.dart";
import "package:sonorus/src/modules/login/login_module.dart";
import "package:sonorus/src/modules/navigation/chat/chat_module.dart";
import "package:sonorus/src/modules/navigation/navigation_module.dart";
import "package:sonorus/src/modules/navigation/opportunity/opportunity_module.dart";
import "package:sonorus/src/modules/navigation/post/post_module.dart";
import "package:sonorus/src/modules/navigation/product/product_module.dart";
import "package:sonorus/src/modules/profile/profile_module.dart";
import "package:sonorus/src/modules/register/register_module.dart";

class AppModule extends Module {
  @override
  List<Module> get imports => [
    CoreModule()
  ];

  @override
  void routes(r) {
    r.module(Modular.initialRoute, module: NavigationModule());
    r.module("/profile", module: ProfileModule());
    r.module("/opportunities", module: OpportunityModule());
    r.module("/posts", module: PostModule());
    r.module("/products", module: ProductModule());
    r.module("/chats", module: ChatModule());
    r.module("/chat", module: ChatRealtimeModule());
    r.module("/login", module: LoginModule());
    r.module("/register", module: RegisterModule());
  }
}