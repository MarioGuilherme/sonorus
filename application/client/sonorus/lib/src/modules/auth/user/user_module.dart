import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/models/user_model.dart";

import "package:sonorus/src/modules/auth/user/user_controller.dart";
import "package:sonorus/src/modules/auth/user/user_page.dart";

class UserModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(() => UserController());
  }

  @override
  void routes(r) {
    r.child("/", child: (context) => UserPage(userId: r.args.data));
  }
}