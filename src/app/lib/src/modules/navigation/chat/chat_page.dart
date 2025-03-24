import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/custom_shimmer.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/modules/navigation/chat/chat_controller.dart";
import "package:sonorus/src/modules/navigation/chat/widgets/chat.dart";
import "package:sonorus/src/modules/navigation/chat/widgets/random_chat_shimmer.dart";

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
    this._statusReactionDisposer = reaction((_) => this._controller.status, (status) async {
      switch (status) {
        case ChatPageStatus.initial:
        case ChatPageStatus.loadingChats:
        case ChatPageStatus.loadedChats:
        case ChatPageStatus.openingChat:
        case ChatPageStatus.openedChat:
          break;
        case ChatPageStatus.error:
          this.hideLoader();
          this.showErrorMessage(this._controller.error);
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
      builder: (_) {
        if (this._controller.status == ChatPageStatus.loadingChats)
          return ListView(
            shrinkWrap: true,
            children: this.createRandomShimmers(() => const RandomChatShimmer())
          );
    
        if (this._controller.chats.isEmpty)
          return Center(child: Text("Ainda sem conversa", style: context.textStyles.textMedium.withFontSize(16)));
    
        return RefreshIndicator(
          onRefresh: this._controller.getChats,
          child: ListView.separated(
            itemBuilder: (_, i) => Chat(chat: this._controller.chats[i]),
            separatorBuilder: (_, __) => const SizedBox(height: 10), 
            itemCount: this._controller.chats.length
          )
        );
      }
    );
  }
}