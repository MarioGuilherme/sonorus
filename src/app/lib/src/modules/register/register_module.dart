import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/register/interests_controller.dart";
import "package:sonorus/src/modules/register/interests_page.dart";
import "package:sonorus/src/modules/register/picture_controller.dart";
import "package:sonorus/src/modules/register/picture_page.dart";
import "package:sonorus/src/modules/register/register_controller.dart";
import "package:sonorus/src/modules/register/register_page.dart";

class RegisterModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(() => RegisterController(Modular.get()));
    i.addLazySingleton(() => PictureController(Modular.get()));
    i.addLazySingleton(() => InterestsController(Modular.get(), Modular.get()));
  }

  @override
  void routes(r) {
    r.child(Modular.initialRoute, child: (context) => const RegisterPage());
    r.child("/picture", child: (context) => const PicturePage());
    r.child("/interests", child: (context) => const InterestsPage());
  }
}