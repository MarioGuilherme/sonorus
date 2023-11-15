import "dart:developer";

import "package:flutter_modular/flutter_modular.dart";
import "package:signalr_core/signalr_core.dart";
import "package:sonorus/src/core/env/env.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/models/state_notification_chat.dart";
import "package:sonorus/src/repositories/auth/auth_repository.dart";
import "package:sonorus/src/repositories/auth/auth_repository_impl.dart";
import "package:sonorus/src/services/auth/auth_service.dart";
import "package:sonorus/src/services/auth/auth_service_impl.dart";

class CoreModule extends Module {
  @override
  void exportedBinds(i) {
    i.addLazySingleton<HubConnection>(() {
      final HubConnection hubConnection = HubConnectionBuilder()
        .withUrl(
          Env.instance["chat_hub_url"]!,
          HttpConnectionOptions(
            logging: (level, message) {
              log(level.name);
              log(level.index.toString());
              log(message);
            }
          )
        )
        .build();
        // hubConnection.on("MessageSent", (message) {
        //   log(message.toString());
        // });
        // hubConnection.on("ReceiveMessage", (message) {
        //   final NotificationChat notificationChat = Modular.get<NotificationChat>();
        //   notificationChat.totaUnreadMessages++;
        //   log(message.toString());
        // });
      return hubConnection;
    });
    i.addLazySingleton<HttpClient>(HttpClient.new);
    i.addLazySingleton<AuthRepository>(AuthRepositoryImpl.new);
    i.addLazySingleton<AuthService>(AuthServiceImpl.new);
    i.addLazySingleton(() => NotificationChat());
    i.addLazySingleton(() => CurrentUserModel());
  }
}