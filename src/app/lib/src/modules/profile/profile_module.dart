import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/profile/profile_controller.dart";
import "package:sonorus/src/modules/profile/profile_page.dart";

class ProfileModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<ProfileController>(() => ProfileController(Modular.get(), Modular.get()));
  }

  @override
  void routes(r) => r.child(Modular.initialRoute, child: (context) => const ProfilePage());
}