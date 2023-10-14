import "dart:developer";

import "package:mobx/mobx.dart";

import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/models/message_model.dart";
import "package:sonorus/src/services/chat/chat_service.dart";

part "chat_controller.g.dart";

class ChatController = ChatControllerBase with _$ChatController;

enum ChatStateStatus {
  initial,
  loadingChats,
  loadedChats,
  openingChat,
  openedChat,
  error
}

abstract class ChatControllerBase with Store {
  final ChatService _chatService;

  @readonly
  ChatStateStatus _chatStatus = ChatStateStatus.initial;

  @readonly
  String? _errorMessage;

  @readonly
  List<ChatModel> _chats = <ChatModel>[];

  @readonly
  ChatModel? _openedChat;

  ChatControllerBase(this._chatService);

  @action
  Future<void> getChats() async {
    try {
      this._chatStatus = ChatStateStatus.loadingChats;
      this._chats = await this._chatService.getChats();
      this._chatStatus = ChatStateStatus.loadedChats;
    } on Exception catch (exception, stackTrace) {
      log("Erro ao buscar as conversas", error: exception, stackTrace: stackTrace);
    }
  }
}