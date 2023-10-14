import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/base/base_page.dart";
import "package:sonorus/src/modules/base/chat/chat_controller.dart";
import "package:sonorus/src/modules/base/chat/chat_module.dart";
import "package:sonorus/src/modules/base/chat/realtime/chat_realtime_controller.dart";
import "package:sonorus/src/modules/base/timeline/timeline_controller.dart";
import "package:sonorus/src/modules/base/timeline/timeline_module.dart";
import "package:sonorus/src/repositories/chat/chat_repository.dart";
import "package:sonorus/src/repositories/chat/chat_repository_impl.dart";
import "package:sonorus/src/repositories/chat/realtime/chat_realtime_repository.dart";
import "package:sonorus/src/repositories/timeline/timeline_repository.dart";
import "package:sonorus/src/repositories/timeline/timeline_repository_impl.dart";
import "package:sonorus/src/services/chat/chat_service.dart";
import "package:sonorus/src/services/chat/chat_service_impl.dart";
import "package:sonorus/src/services/timeline/timeline_service.dart";
import "package:sonorus/src/services/timeline/timeline_service_impl.dart";

class BaseModule extends Module {
  @override
  void binds(i) {
    // TO-DO: Melhorar isto abaixo
    i.addLazySingleton<TimelineRepository>(() => TimelineRepositoryImpl(Modular.get()));
    i.addLazySingleton<TimelineService>(TimelineServiceImpl.new);
    i.addLazySingleton(TimelineController.new);

    i.addLazySingleton<ChatRepository>(() => ChatRepositoryImpl(Modular.get()));
    i.addLazySingleton<ChatService>(ChatServiceImpl.new);
    i.addLazySingleton(ChatController.new);
  }

  @override
  void routes(r) {
    r.child(
      "/",
      child: (context) => const BasePage(),
      children: [
        ModuleRoute(
          "/timeline",
          module: TimelineModule()
        ),
        ModuleRoute(
          "/chats",
          module: ChatModule()
        )
      ]
    );
  }
}