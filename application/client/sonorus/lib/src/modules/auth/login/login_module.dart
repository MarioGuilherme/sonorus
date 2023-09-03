import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/auth/login/login_controller.dart";
import "package:sonorus/src/modules/auth/login/login_page.dart";
import "package:sonorus/src/repositories/auth/auth_repository.dart";
import "package:sonorus/src/repositories/auth/auth_repository_impl.dart";
import "package:sonorus/src/services/auth/auth_service.dart";
import "package:sonorus/src/services/auth/auth_service_impl.dart";

class LoginModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.lazySingleton<AuthRepository>((i) => AuthRepositoryImpl(i())),
    Bind.lazySingleton<AuthService>((i) => AuthServiceImpl(i())),
    Bind.lazySingleton((i) => LoginController(i()))
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute("/", child: (context, args) => const LoginPage()),
  ];
}