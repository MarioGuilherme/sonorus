// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegisterController on RegisterControllerBase, Store {
  late final _$_registerStatusAtom =
      Atom(name: 'RegisterControllerBase._registerStatus', context: context);

  RegisterStateStatus get registerStatus {
    _$_registerStatusAtom.reportRead();
    return super._registerStatus;
  }

  @override
  RegisterStateStatus get _registerStatus => registerStatus;

  @override
  set _registerStatus(RegisterStateStatus value) {
    _$_registerStatusAtom.reportWrite(value, super._registerStatus, () {
      super._registerStatus = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: 'RegisterControllerBase._errorMessage', context: context);

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

  late final _$registerAsyncAction =
      AsyncAction('RegisterControllerBase.register', context: context);

  @override
  Future<void> register(
      String fullname, String nickname, String email, String password) {
    return _$registerAsyncAction
        .run(() => super.register(fullname, nickname, email, password));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
