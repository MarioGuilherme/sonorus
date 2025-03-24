import "dart:developer";

import "package:mobx/mobx.dart";

import "package:sonorus/src/domain/exceptions/chat_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/dtos/view_models/chat_view_model.dart";
import "package:sonorus/src/dtos/view_models/error_sending_message_view_model.dart";
import "package:sonorus/src/dtos/view_models/message_view_model.dart";
import "package:sonorus/src/dtos/view_models/sent_message_view_model.dart";
import "package:sonorus/src/dtos/view_models/user_view_model.dart";
import "package:sonorus/src/services/chat/chat_service.dart";

part "chat_realtime_controller.g.dart";

class ChatRealtimeController = ChatRealtimeControllerBase with _$ChatRealtimeController;

enum ChatRealtimePageStatus {
  initial,
  loadingMessages,
  loadedMessages,
  sendingMessage,
  messageSent,
  error
}

abstract class ChatRealtimeControllerBase with Store {
  final ChatService _service;

  @readonly
  ChatRealtimePageStatus _status = ChatRealtimePageStatus.initial;

  @readonly
  String? _chatId;

  @readonly
  ObservableList<MessageViewModel> _messages = ObservableList<MessageViewModel>();

  @readonly
  List<UserViewModel> _participants = [];

  @readonly
  String? _error;

  ChatRealtimeControllerBase(this._service);

  @action
  void addNewPendentMessage(MessageViewModel message) => this._messages.add(message);

  @action
  void sentMessage(SentMessageViewModel sentMessageViewModel) {
    if (this._chatId == null) this._chatId = sentMessageViewModel.chatId;
    final int index = this._messages.indexWhere((m) => m.messageId == sentMessageViewModel.messageId);
    this._messages[index].sentAt = sentMessageViewModel.sentAt;
  }

  @action
  void addMessage(MessageViewModel message) => this._messages.add(message);

  @action
  void errorSendMessage(ErrorSendingMessageViewModel errorSendingMessageViewModel) {
    if (errorSendingMessageViewModel.messageId != null) this._messages.removeWhere((m) => m.messageId == errorSendingMessageViewModel.messageId);
  }

  @action
  Future<void> getChatByFriendId(int friendId) async {
    try {
      this._status = ChatRealtimePageStatus.loadingMessages;

      final ChatViewModel chat = await this._service.getByFriendId(friendId);
      this._chatId = chat.chatId;
      this._messages.addAll(chat.messages);
      this._participants.addAll(chat.participants);

      this._status = ChatRealtimePageStatus.loadedMessages;
    } on ChatNotFoundException {
      this._status = ChatRealtimePageStatus.loadedMessages;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = ChatRealtimePageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao carregar esta conversa!", error: exception, stackTrace: stackTrace);
    }
  }
}