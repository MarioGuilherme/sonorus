import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/auth/register/interests_controller.dart";
import "package:sonorus/src/modules/auth/register/interests_page.dart";
import "package:sonorus/src/modules/auth/register/picture_controller.dart";
import "package:sonorus/src/modules/auth/register/picture_page.dart";
import "package:sonorus/src/modules/auth/register/register_controller.dart";
import "package:sonorus/src/modules/auth/register/register_page.dart";

class RegisterModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(() => RegisterController(Modular.get()));
    i.addLazySingleton(() => PictureController(Modular.get()));
    i.addLazySingleton(() => InterestsController(Modular.get()));
  }

  @override
  void routes(r) {
    r.child("/", child: (context) => const RegisterPage());
    r.child("/picture", child: (context) => const PicturePage());
    r.child("/interests", child: (context) => const InterestsPage());
  }
}