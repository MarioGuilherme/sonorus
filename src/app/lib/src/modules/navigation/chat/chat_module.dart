import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/navigation/chat/chat_page.dart";

class ChatModule extends Module {
  @override
  void routes(r) => r.child(Modular.initialRoute, child: (context) => const ChatPage());
}