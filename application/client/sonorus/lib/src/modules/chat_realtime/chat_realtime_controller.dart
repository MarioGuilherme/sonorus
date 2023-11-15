import "dart:developer";

import "package:mobx/mobx.dart";
import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/models/message_model.dart";
import "package:sonorus/src/services/chat/realtime/chat_realtime_service.dart";

part "chat_realtime_controller.g.dart";

class ChatRealtimeController = ChatRealtimeControllerBase with _$ChatRealtimeController;

enum ChatRealtimeStateStatus {
  initial,
  loadingMessages,
  messagesLoaded,
  sendingMessage,
  messageSent,
  error
}

abstract class ChatRealtimeControllerBase with Store {
  final ChatRealtimeService _chatRealtimeService;

  @readonly
  ChatRealtimeStateStatus _chatRealtimeStatus = ChatRealtimeStateStatus.initial;

  @readonly
  String? _errorMessage;

  @readonly
  // ignore: prefer_final_fields
  ObservableList<MessageModel> _messages = ObservableList<MessageModel>();

  ChatRealtimeControllerBase(this._chatRealtimeService);

  @action
  Future<void> getMessages(String chatId) async {
    try {
      this._chatRealtimeStatus = ChatRealtimeStateStatus.loadingMessages;
      this._messages.addAll(await this._chatRealtimeService.getMessages(chatId));
      this._chatRealtimeStatus = ChatRealtimeStateStatus.messagesLoaded;
    } on Exception catch (exception, stackTrace) {
      log("Erro ao buscar as mensagens desta conversa", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  void messageSent(List<dynamic> messages) {
    final String messageId = messages.first;
    final List<MessageModel> messagesFounded = this._messages.where((message) => message.messageId == messageId).toList();
    if (messagesFounded.isEmpty)
      log("nao encontrou essa porra");
    else
      this._messages[this._messages.indexWhere((message) => message.messageId == messageId)] = MessageModel(
        content: messagesFounded.first.content,
        isSentByMe: true,
        sentAt: messagesFounded.first.sentAt,
        isSent: true
      );
  }

  @action
  Future<void> receiveMessage(List<dynamic> messages) async {
    final Map<String, dynamic> messageDynamic = messages.first;
    final MessageModel message = MessageModel.fromMap(messageDynamic);
    this._messages.add(message);
  }

  @action
  Future<String?> getChatByFriendId(int friendId) async {
    try {
      this._chatRealtimeStatus = ChatRealtimeStateStatus.loadingMessages;
      final ChatModel chat = await this._chatRealtimeService.getChatByFriendId(friendId);
      this._messages.addAll(chat.messages!);
      this._chatRealtimeStatus = ChatRealtimeStateStatus.messagesLoaded;
      return chat.chatId;
    } on Exception catch (exception, stackTrace) {
      log("Erro ao buscar as mensagens desta conversa", error: exception, stackTrace: stackTrace);
      return "";
    }
  }

  @action
  void sendMyPendentMessage(MessageModel message) {
    try {
      this._messages.add(message);
    } on Exception catch (exception, stackTrace) {
      log("Erro ao buscar as mensagens desta conversa", error: exception, stackTrace: stackTrace);
    }
  }
}