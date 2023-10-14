import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/modules/base/chat/chat_controller.dart";
import "package:sonorus/src/modules/base/chat/chat_page.dart";
import "package:sonorus/src/repositories/chat/chat_repository.dart";
import "package:sonorus/src/repositories/chat/chat_repository_impl.dart";
import "package:sonorus/src/services/chat/chat_service.dart";
import "package:sonorus/src/services/chat/chat_service_impl.dart";

class ChatModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<ChatRepository>(() => ChatRepositoryImpl(Modular.get()));
    i.addLazySingleton<ChatService>(ChatServiceImpl.new);
    i.addLazySingleton(ChatController.new);
  }
 
  @override
  void routes(r) {
    r.child("/", child: (context) => const ChatPage());
  }
}