// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatController on ChatControllerBase, Store {
  late final _$_chatStatusAtom =
      Atom(name: 'ChatControllerBase._chatStatus', context: context);

  ChatStateStatus get chatStatus {
    _$_chatStatusAtom.reportRead();
    return super._chatStatus;
  }

  @override
  ChatStateStatus get _chatStatus => chatStatus;

  @override
  set _chatStatus(ChatStateStatus value) {
    _$_chatStatusAtom.reportWrite(value, super._chatStatus, () {
      super._chatStatus = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: 'ChatControllerBase._errorMessage', context: context);

  String? get errorMessage {
    _$_errorMessageAtom.reportRead();
    return super._errorMessage;
  }

  @override
  String? get _errorMessage => errorMessage;

  @override
  set _errorMessage(String? value) {
    _$_errorMessageAtom.reportWrite(value, super._errorMessage, () {
      super._errorMessage = value;
    });
  }

  late final _$_chatsAtom =
      Atom(name: 'ChatControllerBase._chats', context: context);

  List<ChatModel> get chats {
    _$_chatsAtom.reportRead();
    return super._chats;
  }

  @override
  List<ChatModel> get _chats => chats;

  @override
  set _chats(List<ChatModel> value) {
    _$_chatsAtom.reportWrite(value, super._chats, () {
      super._chats = value;
    });
  }

  late final _$_openedChatAtom =
      Atom(name: 'ChatControllerBase._openedChat', context: context);

  ChatModel? get openedChat {
    _$_openedChatAtom.reportRead();
    return super._openedChat;
  }

  @override
  ChatModel? get _openedChat => openedChat;

  @override
  set _openedChat(ChatModel? value) {
    _$_openedChatAtom.reportWrite(value, super._openedChat, () {
      super._openedChat = value;
    });
  }

  late final _$getChatsAsyncAction =
      AsyncAction('ChatControllerBase.getChats', context: context);

  @override
  Future<void> getChats() {
    return _$getChatsAsyncAction.run(() => super.getChats());
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
