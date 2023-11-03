import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mobx/mobx.dart";
import "package:signalr_core/signalr_core.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/custom_shimmer.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/utils/routes.dart";
import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/models/message_model.dart";

import "package:sonorus/src/modules/chat_realtime/chat_realtime_controller.dart";
import "package:sonorus/src/modules/chat_realtime/widgets/message.dart";
import "package:sonorus/src/modules/chat_realtime/widgets/random_message_shimmer.dart";

class ChatRealtimePage extends StatefulWidget {
  final ChatModel chat;
  final String? newMessage;

  const ChatRealtimePage({
    super.key,
    required this.chat,
    this.newMessage
  });

  @override
  State<ChatRealtimePage> createState() => _ChatRealtimePageState();
}

class _ChatRealtimePageState extends State<ChatRealtimePage> with Messages, CustomShimmer {
  final _messageEC = TextEditingController();
  final HubConnection _hubConnection = Modular.get<HubConnection>();
  final ChatRealtimeController _controller = Modular.get<ChatRealtimeController>();
  late final ReactionDisposer _statusReactionDisposer;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    this._hubConnection.start();
    this._hubConnection.on("MessageSent", (message) {
      this._controller.receiveMessage(message!);
      log(message.toString());
    });
    this._hubConnection.on("ReceiveMessage", (message) {
      this._controller.receiveMessage(message!);
      log(message.toString());
    });

    this._statusReactionDisposer = reaction((_) => this._controller.chatRealtimeStatus, (status) async {
      switch (status) {
        case ChatRealtimeStateStatus.initial:
        case ChatRealtimeStateStatus.loadingMessages:
        case ChatRealtimeStateStatus.messagesLoaded:
        case ChatRealtimeStateStatus.sendingMessage:
        case ChatRealtimeStateStatus.messageSent: break;
        case ChatRealtimeStateStatus.error:
          this.showMessage("Ops", this._controller.errorMessage ?? "Erro não mapeado");
          break;
      }
    });

    if (this.widget.chat.chatId != null)
      this._controller.getMessages(this.widget.chat.chatId!);
    else {
      this._messageEC.text = this.widget.newMessage ?? "";
      this._focusNode.requestFocus();
      this._controller.getMessagesByFriendId(this.widget.chat.friend.userId);
    }

    super.initState();
  }

  @override
  void dispose() {
    this._statusReactionDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF373739),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (this.widget.chat.chatId != null)
              IconButton(
                onPressed: () => Modular.to.navigate(Routes.chatsPage),
                splashRadius: 25,
                style: IconButton.styleFrom(iconSize: 2),
                icon: const Icon(Icons.arrow_back)
              ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(200)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: Image.network(
                        this.widget.chat.friend.picture,
                        width: 35,
                        height: 35,
                        fit: BoxFit.cover
                      )
                    )
                  ),
                  const SizedBox(width: 10),
                  Text(
                    this.widget.chat.friend.nickname,
                    textAlign: TextAlign.start,
                    style: context.textStyles.textMedium.copyWith(fontSize: 14.sp)
                  )
                ]
              )
            )
          ]
        )
      ),
      body: Column(
        children: [
          Expanded(
            child: Observer(
              builder: (_) {
                if (this._controller.chatRealtimeStatus == ChatRealtimeStateStatus.loadingMessages)
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView(
                      shrinkWrap: true,
                      children: this.createRandomShimmers(() => const RandomMessageShimmer())
                    )
                  );
                if (!this._controller.messages.isNotEmpty)
                  return Center(
                    child: Text(
                      "Nenhuma mensagem",
                      style: context.textStyles.textMedium.copyWith(
                        fontSize: 14.sp,
                        color: Colors.white
                      )
                    )
                  );
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: this._controller.messages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12.5),
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (_, i) {
                    final MessageModel message = this._controller.messages[i];
                    return message.isSentByMe
                      ? Message.myMessage(message: this._controller.messages[i])
                      : Message.friendMessage(
                          friend: this.widget.chat.friend,
                          message: message
                        );
                  }
                );
              }
            )
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: const Color(0xFF373739),
            height: 70,
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    child: TextFormField(
                      controller: this._messageEC,
                      focusNode: this._focusNode,
                      textInputAction: TextInputAction.send,
                      style: context.textStyles.textRegular.copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Escreva a sua mensagem...",
                        hintStyle: context.textStyles.textMedium.copyWith(color: Colors.white, fontSize: 14.sp),
                        contentPadding: const EdgeInsets.only(left: 16)
                      )
                    )
                  )
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Material(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.transparent,
                      child: IconButton.outlined(
                        icon: Icon(Icons.send, color: context.colors.primary, size: 28),
                        onPressed: () {
                          final CurrentUserModel currentUser = Modular.get<CurrentUserModel>();
                          this._hubConnection.invoke(
                            "SendMessage",
                            args: [
                              this.widget.chat.chatId,
                              currentUser.userId,
                              this._messageEC.text
                            ]
                          );
                          this._messageEC.text = "";
                        }
                      )
                    )
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }
}