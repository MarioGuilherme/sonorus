import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/auth/login/login_module.dart";
import "package:sonorus/src/modules/auth/user/user_module.dart";
import "package:sonorus/src/modules/auth/register/register_module.dart";
import "package:sonorus/src/modules/base/base_module.dart";
import "package:sonorus/src/modules/base/marketplace/marketplace_module.dart";
import "package:sonorus/src/modules/chat_realtime/chat_realtime_module.dart";
import "package:sonorus/src/modules/core/core_module.dart";
import "package:sonorus/src/modules/teste/teste_module.dart";

class AppModule extends Module {
  @override
  List<Module> get imports => [
    CoreModule()
  ];

  @override
  void routes(r) {
    r.module("/", module: BaseModule());
    r.module("/marketplace/", module: MarketplaceModule());
    r.module("/teste/", module: TesteModule());
    r.module("/user/", module: UserModule());
    r.module("/chat/", module: ChatRealtimeModule());
    r.module("/login/", module: LoginModule());
    r.module("/register/", module: RegisterModule());
  }
}