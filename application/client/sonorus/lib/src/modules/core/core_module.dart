import "dart:developer";

import "package:flutter_modular/flutter_modular.dart";
import "package:signalr_core/signalr_core.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/repositories/auth/auth_repository.dart";
import "package:sonorus/src/repositories/auth/auth_repository_impl.dart";
import "package:sonorus/src/services/auth/auth_service.dart";
import "package:sonorus/src/services/auth/auth_service_impl.dart";

class CoreModule extends Module {
  @override
  void exportedBinds(i) {
    i.addLazySingleton<HttpClient>(HttpClient.new);
    i.addLazySingleton<AuthRepository>(AuthRepositoryImpl.new);
    i.addLazySingleton<AuthService>(AuthServiceImpl.new);
    i.addLazySingleton(() => CurrentUserModel(
      userId: 1,
      email: "marioguilhermedev@gmail.com",
      fullName: "Mário Guilherme de Andrade Rodrigues",
      nickname: "dev.mario.guilherme",
      picture: "https://mgaroteste1.blob.core.windows.net/pictures-user/defaultPicture.png"
    ));
  }
}