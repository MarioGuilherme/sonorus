// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatController on ChatControllerBase, Store {
  late final _$_statusAtom =
      Atom(name: 'ChatControllerBase._status', context: context);

  ChatPageStatus get status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  ChatPageStatus get _status => status;

  @override
  set _status(ChatPageStatus value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
    });
  }

  late final _$_chatsAtom =
      Atom(name: 'ChatControllerBase._chats', context: context);

  ObservableList<ChatViewModel> get chats {
    _$_chatsAtom.reportRead();
    return super._chats;
  }

  @override
  ObservableList<ChatViewModel> get _chats => chats;

  @override
  set _chats(ObservableList<ChatViewModel> value) {
    _$_chatsAtom.reportWrite(value, super._chats, () {
      super._chats = value;
    });
  }

  late final _$_errorAtom =
      Atom(name: 'ChatControllerBase._error', context: context);

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
