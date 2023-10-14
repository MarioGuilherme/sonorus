import "dart:developer";

import "package:flutter_modular/flutter_modular.dart";
import "package:signalr_core/signalr_core.dart";

import "package:sonorus/src/modules/base/chat/realtime/chat_realtime_controller.dart";
import "package:sonorus/src/modules/base/chat/realtime/chat_realtime_page.dart";
import "package:sonorus/src/repositories/chat/realtime/chat_realtime_repository.dart";
import "package:sonorus/src/repositories/chat/realtime/chat_realtime_repository_impl.dart";
import "package:sonorus/src/services/chat/realtime/chat_realtime_service.dart";
import "package:sonorus/src/services/chat/realtime/chat_realtime_service_impl.dart";

class ChatRealtimeModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<HubConnection>(() {
      final HubConnection hubConnection = HubConnectionBuilder()
        .withUrl(
          "http://192.168.1.118:5115/chatHub",
          HttpConnectionOptions(logging: (level, message) {
            print(level);
          })
        )
        .build();
      return hubConnection;
    });
    i.addLazySingleton<ChatRealtimeRepository>(() => ChatRealtimeRepositoryImpl(Modular.get()));
    i.addLazySingleton<ChatRealtimeService>(ChatRealtimeServiceImpl.new);
    i.addLazySingleton(ChatRealtimeController.new);
  }

  @override
  void routes(r) {
    r.child("/:chatId",
      child: (context) => ChatRealtimePage(chat: r.args.data)
    );
  }
}