import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mobx/mobx.dart";
import "package:signalr_core/signalr_core.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/custom_shimmer.dart";

import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/modules/base/chat/chat_controller.dart";
import "package:sonorus/src/modules/base/chat/widgets/chat.dart";
import "package:sonorus/src/modules/base/chat/widgets/random_chat_shimmer.dart";
import "package:sonorus/src/modules/base/timeline/widgets/random_post_shimmer.dart";

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with Loader, Messages, CustomShimmer {
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
        case ChatStateStatus.openedChat: break;
        case ChatStateStatus.error:
          this.showMessage("Ops", this._controller.errorMessage ?? "Erro não mapeado");
          break;
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Observer(
        builder: (_) {
          if (this._controller.chatStatus == ChatStateStatus.loadingChats)
            return ListView(
              shrinkWrap: true,
              children: this.createRandomShimmers(() => const RandomChatShimmer())
            );
          if (this._controller.chats.isEmpty)
            return Center(
              child: Text(
                "Ainda sem conversa",
                style: context.textStyles.textMedium.copyWith(
                  fontSize: 16.sp,
                  color: Colors.white
                )
              )
            );
          return ListView.separated(
            itemBuilder: (_, i) => Chat(chat: this._controller.chats[i]),
            separatorBuilder: (_, __) => const SizedBox(height: 10), 
            itemCount: this._controller.chats.length
          );
        }
      )
    );
  }
}