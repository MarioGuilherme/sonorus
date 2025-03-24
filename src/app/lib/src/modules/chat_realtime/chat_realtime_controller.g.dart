// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_realtime_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatRealtimeController on ChatRealtimeControllerBase, Store {
  late final _$_statusAtom =
      Atom(name: 'ChatRealtimeControllerBase._status', context: context);

  ChatRealtimePageStatus get status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  ChatRealtimePageStatus get _status => status;

  @override
  set _status(ChatRealtimePageStatus value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
    });
  }

  late final _$_chatIdAtom =
      Atom(name: 'ChatRealtimeControllerBase._chatId', context: context);

  String? get chatId {
    _$_chatIdAtom.reportRead();
    return super._chatId;
  }

  @override
  String? get _chatId => chatId;

  @override
  set _chatId(String? value) {
    _$_chatIdAtom.reportWrite(value, super._chatId, () {
      super._chatId = value;
    });
  }

  late final _$_messagesAtom =
      Atom(name: 'ChatRealtimeControllerBase._messages', context: context);

  ObservableList<MessageViewModel> get messages {
    _$_messagesAtom.reportRead();
    return super._messages;
  }

  @override
  ObservableList<MessageViewModel> get _messages => messages;

  @override
  set _messages(ObservableList<MessageViewModel> value) {
    _$_messagesAtom.reportWrite(value, super._messages, () {
      super._messages = value;
    });
  }

  late final _$_participantsAtom =
      Atom(name: 'ChatRealtimeControllerBase._participants', context: context);

  List<UserViewModel> get participants {
    _$_participantsAtom.reportRead();
    return super._participants;
  }

  @override
  List<UserViewModel> get _participants => participants;

  @override
  set _participants(List<UserViewModel> value) {
    _$_participantsAtom.reportWrite(value, super._participants, () {
      super._participants = value;
    });
  }

  late final _$_errorAtom =
      Atom(name: 'ChatRealtimeControllerBase._error', context: context);

  String? get error {
    _$_errorAtom.reportRead();
    return super._error;
  }

  @override
  String? get _error => error;

  @override
  set _error(String? value) {
    _$_errorAtom.reportWrite(value, super._error, () {
      super._error = value;
    });
  }

  late final _$getChatByFriendIdAsyncAction = AsyncAction(
      'ChatRealtimeControllerBase.getChatByFriendId',
      context: context);

  @override
  Future<void> getChatByFriendId(int friendId) {
    return _$getChatByFriendIdAsyncAction
        .run(() => super.getChatByFriendId(friendId));
  }

  late final _$ChatRealtimeControllerBaseActionController =
      ActionController(name: 'ChatRealtimeControllerBase', context: context);

  @override
  void addNewPendentMessage(MessageViewModel message) {
    final _$actionInfo = _$ChatRealtimeControllerBaseActionController
        .startAction(name: 'ChatRealtimeControllerBase.addNewPendentMessage');
    try {
      return super.addNewPendentMessage(message);
    } finally {
      _$ChatRealtimeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sentMessage(SentMessageViewModel sentMessageViewModel) {
    final _$actionInfo = _$ChatRealtimeControllerBaseActionController
        .startAction(name: 'ChatRealtimeControllerBase.sentMessage');
    try {
      return super.sentMessage(sentMessageViewModel);
    } finally {
      _$ChatRealtimeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addMessage(MessageViewModel message) {
    final _$actionInfo = _$ChatRealtimeControllerBaseActionController
        .startAction(name: 'ChatRealtimeControllerBase.addMessage');
    try {
      return super.addMessage(message);
    } finally {
      _$ChatRealtimeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void errorSendMessage(
      ErrorSendingMessageViewModel errorSendingMessageViewModel) {
    final _$actionInfo = _$ChatRealtimeControllerBaseActionController
        .startAction(name: 'ChatRealtimeControllerBase.errorSendMessage');
    try {
      return super.errorSendMessage(errorSendingMessageViewModel);
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
