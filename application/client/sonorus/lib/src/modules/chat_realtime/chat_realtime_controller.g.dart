// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_realtime_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatRealtimeController on ChatRealtimeControllerBase, Store {
  late final _$_chatRealtimeStatusAtom = Atom(
      name: 'ChatRealtimeControllerBase._chatRealtimeStatus', context: context);

  ChatRealtimeStateStatus get chatRealtimeStatus {
    _$_chatRealtimeStatusAtom.reportRead();
    return super._chatRealtimeStatus;
  }

  @override
  ChatRealtimeStateStatus get _chatRealtimeStatus => chatRealtimeStatus;

  @override
  set _chatRealtimeStatus(ChatRealtimeStateStatus value) {
    _$_chatRealtimeStatusAtom.reportWrite(value, super._chatRealtimeStatus, () {
      super._chatRealtimeStatus = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: 'ChatRealtimeControllerBase._errorMessage', context: context);

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

  late final _$_messagesAtom =
      Atom(name: 'ChatRealtimeControllerBase._messages', context: context);

  ObservableList<MessageModel> get messages {
    _$_messagesAtom.reportRead();
    return super._messages;
  }

  @override
  ObservableList<MessageModel> get _messages => messages;

  @override
  set _messages(ObservableList<MessageModel> value) {
    _$_messagesAtom.reportWrite(value, super._messages, () {
      super._messages = value;
    });
  }

  late final _$getMessagesAsyncAction =
      AsyncAction('ChatRealtimeControllerBase.getMessages', context: context);

  @override
  Future<void> getMessages(String chatId) {
    return _$getMessagesAsyncAction.run(() => super.getMessages(chatId));
  }

  late final _$receiveMessageAsyncAction = AsyncAction(
      'ChatRealtimeControllerBase.receiveMessage',
      context: context);

  @override
  Future<void> receiveMessage(List<dynamic> messages) {
    return _$receiveMessageAsyncAction
        .run(() => super.receiveMessage(messages));
  }

  late final _$getChatByFriendIdAsyncAction = AsyncAction(
      'ChatRealtimeControllerBase.getChatByFriendId',
      context: context);

  @override
  Future<String?> getChatByFriendId(int friendId) {
    return _$getChatByFriendIdAsyncAction
        .run(() => super.getChatByFriendId(friendId));
  }

  late final _$ChatRealtimeControllerBaseActionController =
      ActionController(name: 'ChatRealtimeControllerBase', context: context);

  @override
  void messageSent(List<dynamic> messages) {
    final _$actionInfo = _$ChatRealtimeControllerBaseActionController
        .startAction(name: 'ChatRealtimeControllerBase.messageSent');
    try {
      return super.messageSent(messages);
    } finally {
      _$ChatRealtimeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sendMyPendentMessage(MessageModel message) {
    final _$actionInfo = _$ChatRealtimeControllerBaseActionController
        .startAction(name: 'ChatRealtimeControllerBase.sendMyPendentMessage');
    try {
      return super.sendMyPendentMessage(message);
    } finally {
      _$ChatRealtimeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
