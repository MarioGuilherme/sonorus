import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/modules/chat_realtime/chat_realtime_controller.dart";
import "package:sonorus/src/modules/chat_realtime/chat_realtime_page.dart";
import "package:sonorus/src/repositories/chat/realtime/chat_realtime_repository.dart";
import "package:sonorus/src/repositories/chat/realtime/chat_realtime_repository_impl.dart";
import "package:sonorus/src/services/chat/realtime/chat_realtime_service.dart";
import "package:sonorus/src/services/chat/realtime/chat_realtime_service_impl.dart";

class ChatRealtimeModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<ChatRealtimeRepository>(() => ChatRealtimeRepositoryImpl(Modular.get()));
    i.addLazySingleton<ChatRealtimeService>(ChatRealtimeServiceImpl.new);
    i.addLazySingleton(ChatRealtimeController.new);
  }

  @override
  void routes(r) {
    r.child("/:chatId",
      child: (context) {
        if (r.args.data.runtimeType.toString() == "ChatModel")
          return ChatRealtimePage(chat: r.args.data);

        final String? newMessage = r.args.data?[0];
        final ChatModel chat = r.args.data?[1] ?? r.args.data;
        return ChatRealtimePage(chat: chat, newMessage: newMessage);
      }
    );
  }
}