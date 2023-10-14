import "dart:developer";

import "package:mobx/mobx.dart";
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
  Future<void> receiveMessage(List<dynamic> messages) async {
    final Map<String, dynamic> messageDynamic = messages.first;
    final MessageModel message = MessageModel.fromMap(messageDynamic);
    this._messages.add(message);
  }
}