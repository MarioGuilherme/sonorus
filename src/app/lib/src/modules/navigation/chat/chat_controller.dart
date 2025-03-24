import "dart:developer";

import "package:mobx/mobx.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";

import "package:sonorus/src/dtos/view_models/chat_view_model.dart";
import "package:sonorus/src/services/chat/chat_service.dart";

part "chat_controller.g.dart";

class ChatController = ChatControllerBase with _$ChatController;

enum ChatPageStatus {
  initial,
  loadingChats,
  loadedChats,
  openingChat,
  openedChat,
  error
}

abstract class ChatControllerBase with Store {
  final ChatService _service;

  @readonly
  ChatPageStatus _status = ChatPageStatus.initial;

  @readonly
  ObservableList<ChatViewModel> _chats = ObservableList();

  @readonly
  String? _error;

  ChatControllerBase(this._service);

  @action
  Future<void> getChats() async {
    try {
      this._status = ChatPageStatus.loadingChats;

      this._chats.clear();
      this._chats.addAll(await this._service.getAll());

      this._status = ChatPageStatus.loadedChats;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = ChatPageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao buscar as conversas!", error: exception, stackTrace: stackTrace);
    }
  }
}