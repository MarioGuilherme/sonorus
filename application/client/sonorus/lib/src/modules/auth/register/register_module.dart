import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/auth/register/interests_controller.dart";
import "package:sonorus/src/modules/auth/register/interests_page.dart";
import "package:sonorus/src/modules/auth/register/picture_controller.dart";
import "package:sonorus/src/modules/auth/register/picture_page.dart";
import "package:sonorus/src/modules/auth/register/register_controller.dart";
import "package:sonorus/src/modules/auth/register/register_page.dart";
import "package:sonorus/src/repositories/auth/auth_repository.dart";
import "package:sonorus/src/repositories/auth/auth_repository_impl.dart";

class RegisterModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.lazySingleton<AuthRepository>((i) => AuthRepositoryImpl(i())),
    Bind.lazySingleton((i) => RegisterController(i())),
    Bind.lazySingleton((i) => PictureController(i())),
    Bind.lazySingleton((i) => InterestsController(i())),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute("/", child: (context, args) => const RegisterPage()),
    ChildRoute("/picture", child: (context, args) => const PicturePage()),
    ChildRoute("/interests", child: (context, args) => const InterestsPage()),
  ];
}