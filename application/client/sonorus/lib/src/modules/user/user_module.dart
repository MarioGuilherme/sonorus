import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/modules/user/user_controller.dart";

import "package:sonorus/src/modules/user/user_page.dart";
import "package:sonorus/src/repositories/user/user_repository.dart";
import "package:sonorus/src/repositories/user/user_repository_impl.dart";
import "package:sonorus/src/services/user/user_service.dart";
import "package:sonorus/src/services/user/user_service_impl.dart";

class UserModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<UserRepository>(() => UserRepositoryImpl(Modular.get()));
    i.addLazySingleton<UserService>(UserServiceImpl.new);
    i.addLazySingleton(UserController.new);
  }

  @override
  void routes(r) {
    r.child("/", child: (context) => const UserPage());
  }
}