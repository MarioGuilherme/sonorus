import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/current_user_model.dart";

class CoreModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.lazySingleton((i) => HttpClient(), export: true),
    Bind.lazySingleton<CurrentUserModel>(
      (i) => CurrentUserModel(
        idUser: 1,
        email: "marioguilhermedev@gmail.com",
        fullName: "Mário Guilherme de Andrade Rodrigues",
        nickname: "dev.mario.guilherme",
        picture: "defaultPicture.png"
      ),
      export: true
    )
    // Bind.lazySingleton<CurrentUserModel>((i) => CurrentUserModel(), export: true)
  ];
}