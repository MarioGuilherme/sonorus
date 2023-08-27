import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/modules/core/core_module.dart";
import "package:sonorus/src/modules/auth/login/login_module.dart";
import "package:sonorus/src/modules/auth/register/register_module.dart";
import "package:sonorus/src/modules/timeline/timeline_module.dart";


class AppModule extends Module {
  @override
  List<Module> get imports => [
    CoreModule()
  ];

  @override
  List<ModularRoute> get routes => [
    ModuleRoute("/login/", module: LoginModule()),
    ModuleRoute("/register/", module: RegisterModule()),
    ModuleRoute("/timeline/", module: TimelineModule()),
  ];
}