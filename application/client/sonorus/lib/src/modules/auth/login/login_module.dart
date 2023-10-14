import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/auth/login/login_controller.dart";
import "package:sonorus/src/modules/auth/login/login_page.dart";

class LoginModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(() => LoginController(Modular.get()));
  }

  @override
  void routes(r) {
    r.child("/", child: (context) => const LoginPage());
  }
}