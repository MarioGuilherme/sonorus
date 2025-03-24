import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:mobx/mobx.dart";
import "package:signalr_netcore/hub_connection.dart";

import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/custom_shimmer.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/core/utils/random_id.dart";
import "package:sonorus/src/domain/models/authenticated_user.dart";
import "package:sonorus/src/dtos/input_models/add_message_to_chat_input_model.dart";
import "package:sonorus/src/dtos/view_models/error_sending_message_view_model.dart";
import "package:sonorus/src/dtos/view_models/message_view_model.dart";
import "package:sonorus/src/dtos/view_models/sent_message_view_model.dart";
import "package:sonorus/src/dtos/view_models/user_view_model.dart";
import "package:sonorus/src/modules/chat_realtime/chat_realtime_controller.dart";
import "package:sonorus/src/modules/chat_realtime/widgets/message.dart";
import "package:sonorus/src/modules/chat_realtime/widgets/random_message_shimmer.dart";
import "package:sonorus/src/modules/navigation/widgets/picture_user.dart";

class ChatRealtimePage extends StatefulWidget {
  final UserViewModel friend;
  final String? initialMessage;

  const ChatRealtimePage({
    required this.friend,
    this.initialMessage,
    super.key
  });

  @override
  State<ChatRealtimePage> createState() => _ChatRealtimePageState();
}

class _ChatRealtimePageState extends State<ChatRealtimePage> with Messages, Loader, CustomShimmer {
  final ChatRealtimeController _controller = Modular.get<ChatRealtimeController>();
  final TextEditingController _messageEC = TextEditingController();
  final HubConnection _hubConnection = Modular.get<HubConnection>();
  final AuthenticatedUser _authenticatedUser = Modular.get<AuthenticatedUser>();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    this._controller.getChatByFriendId(this.widget.friend.userId);
    this._messageEC.text = this.widget.initialMessage ?? "";
    if (this._messageEC.text.isNotEmpty) this._focusNode.requestFocus();

    this._hubConnection.off("SentMessage");
    this._hubConnection.off("ReceiveMessage");
    this._hubConnection.off("ErrorSendingMessage");
    this._hubConnection.on("SentMessage", (args) {
      final SentMessageViewModel sentMessageViewModel = SentMessageViewModel.fromMap(args!.first as Map<String, dynamic>);
      this._controller.sentMessage(sentMessageViewModel);
      setState(() { });
      this._scrollController.animateTo(
        this._scrollController.position.maxScrollExtent * 2,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut
      );
    });
    this._hubConnection.on("ReceiveMessage", (args) {
      final MessageViewModel message = MessageViewModel.fromMap(args!.first as Map<String, dynamic>);
      this._controller.addMessage(message);
      this._scrollController.animateTo(
        this._scrollController.position.maxScrollExtent * 2,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut
      );
    });
    this._hubConnection.on("ErrorSendingMessage", (args) {
      final ErrorSendingMessageViewModel errorSendingMessageViewModel = ErrorSendingMessageViewModel.fromMap(args!.first as Map<String, dynamic>);
      this._controller.errorSendMessage(errorSendingMessageViewModel);
      this.showErrorMessage("Erro ao enviar sua mensagem!\n(${errorSendingMessageViewModel.errors.fold("", (previousValue, element) => "$previousValue$element").trim()})");
    });

    this._statusReactionDisposer = reaction((_) => this._controller.status, (status) async {
      switch (status) {
        case ChatRealtimePageStatus.initial:
        case ChatRealtimePageStatus.loadingMessages:
        case ChatRealtimePageStatus.sendingMessage:
        case ChatRealtimePageStatus.messageSent:
          break;
        case ChatRealtimePageStatus.loadedMessages:
          Future.delayed(Duration(milliseconds: 10)).then((_) => this._scrollController.animateTo(
            this._scrollController.position.maxScrollExtent * 2,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut
          ));
          break;
        case ChatRealtimePageStatus.error:
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

  void _sendMessage() {
    if (this._hubConnection.state != HubConnectionState.Connected) return;

    final String message = this._messageEC.text;

    if (message.isEmpty) return;

    final MessageViewModel messageViewModel = MessageViewModel(
      messageId: RandomId.randomId(),
      content: message,
      sentByUserId: this._authenticatedUser.userId!
    );

    this._controller.addNewPendentMessage(messageViewModel);
    this._hubConnection.invoke(
      "SendMessage",
      args: [
        AddMessageToChatInputModel(
          chatId: this._controller.chatId,
          messageId: messageViewModel.messageId!,
          participants: [this._authenticatedUser.userId!, this.widget.friend.userId],
          content: message
        ).toJson()
      ]
    );
    this._messageEC.clear();
    this._scrollController.animateTo(
      this._scrollController.position.maxScrollExtent * 2,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF373739),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.5))),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PictureUser(picture: Image.network(this.widget.friend.picture, width: 40, height: 40, fit: BoxFit.cover)),
              const SizedBox(width: 20),
              Flexible(child: Text(this.widget.friend.nickname, style: context.textStyles.textMedium.withFontSize(16)))
            ]
          )
        )
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Observer(
                builder: (_) {
                  if (this._controller.status == ChatRealtimePageStatus.loadingMessages)
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView(shrinkWrap: true, children: this.createRandomShimmers(() => const RandomMessageShimmer()))
                    );
        
                  if (!this._controller.messages.isNotEmpty)
                    return Center(child: Text("Nenhuma mensagem", style: context.textStyles.textMedium.withFontSize(14)));
        
                  return Observer(
                    builder: (context) {
                      return ListView.separated(
                        controller: this._scrollController,
                        shrinkWrap: true,
                        itemCount: this._controller.messages.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12.5),
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (_, i) {
                          final MessageViewModel message = this._controller.messages[i];
                          return message.sentByUserId == this._authenticatedUser.userId!
                            ? Message.myMessage(messageViewModel: this._controller.messages[i])
                            : Message.friendMessage(author: this.widget.friend, messageViewModel: message);
                        }
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
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.length == 255) this._messageEC.text = value.substring(0, 255);
                      },
                      controller: this._messageEC,
                      focusNode: this._focusNode,
                      textInputAction: TextInputAction.send,
                      onFieldSubmitted: (value) => this._sendMessage,
                      style: context.textStyles.textRegular,
                      decoration: InputDecoration(
                        hintText: "Escreva a sua mensagem...",
                        hintStyle: context.textStyles.textMedium.withFontSize(14),
                        contentPadding: const EdgeInsets.only(left: 16)
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
                        child: IconButton.outlined(icon: Icon(Icons.send, color: context.colors.primary, size: 28), onPressed: this._sendMessage)
                      )
                    )
                  )
                ]
              )
            )
          ]
        ),
      )
    );
  }
}