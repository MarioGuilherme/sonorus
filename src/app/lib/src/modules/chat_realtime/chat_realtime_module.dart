import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/dtos/view_models/user_view_model.dart";
import "package:sonorus/src/modules/chat_realtime/chat_realtime_controller.dart";
import "package:sonorus/src/modules/chat_realtime/chat_realtime_page.dart";

class ChatRealtimeModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<ChatRealtimeController>(() => ChatRealtimeController(Modular.get()));
  }

  @override
  void routes(r) {
    r.child("/:friendId", child: (context) {
      final List<dynamic> args = r.args.data;
      final UserViewModel friend = args.elementAt(0);
      final String? initialMessage = args.elementAtOrNull(1);

      return ChatRealtimePage(friend: friend, initialMessage: initialMessage);
    });
  }
}