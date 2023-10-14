import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mobx/mobx.dart";
import "package:signalr_core/signalr_core.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";

import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/modules/base/chat/chat_controller.dart";
import "package:sonorus/src/modules/base/chat/widgets/chat.dart";

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with Loader, Messages {
  final ChatController _controller = Modular.get<ChatController>();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._controller.getChats();

    this._statusReactionDisposer = reaction((_) => this._controller.chatStatus, (status) async {
      switch (status) {
        case ChatStateStatus.initial:
        case ChatStateStatus.loadingChats:
        case ChatStateStatus.loadedChats:
        case ChatStateStatus.openingChat:
        case ChatStateStatus.openedChat:
        case ChatStateStatus.error:break;
      }
    });
  
    super.initState();
  }

  @override
  void dispose() {
    this._statusReactionDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => this._controller.chats.isEmpty
      ? Center(
          child: Text(
            "Ainda sem conversa",
            style: context.textStyles.textMedium.copyWith(
              fontSize: 16.sp,
              color: Colors.white
            )
          )
        )
      : ListView.separated(
          itemBuilder: (_, i) => Chat(chat: this._controller.chats[i]),
          separatorBuilder: (_, __) => const SizedBox(height: 10), 
          itemCount: this._controller.chats.length
        )
    );
  }
}