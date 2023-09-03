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

  late final _$_fullnameInputErrorsAtom = Atom(
      name: 'RegisterControllerBase._fullnameInputErrors', context: context);

  String? get fullnameInputErrors {
    _$_fullnameInputErrorsAtom.reportRead();
    return super._fullnameInputErrors;
  }

  @override
  String? get _fullnameInputErrors => fullnameInputErrors;

  @override
  set _fullnameInputErrors(String? value) {
    _$_fullnameInputErrorsAtom.reportWrite(value, super._fullnameInputErrors,
        () {
      super._fullnameInputErrors = value;
    });
  }

  late final _$_nicknameInputErrorsAtom = Atom(
      name: 'RegisterControllerBase._nicknameInputErrors', context: context);

  String? get nicknameInputErrors {
    _$_nicknameInputErrorsAtom.reportRead();
    return super._nicknameInputErrors;
  }

  @override
  String? get _nicknameInputErrors => nicknameInputErrors;

  @override
  set _nicknameInputErrors(String? value) {
    _$_nicknameInputErrorsAtom.reportWrite(value, super._nicknameInputErrors,
        () {
      super._nicknameInputErrors = value;
    });
  }

  late final _$_emailInputErrorsAtom =
      Atom(name: 'RegisterControllerBase._emailInputErrors', context: context);

  String? get emailInputErrors {
    _$_emailInputErrorsAtom.reportRead();
    return super._emailInputErrors;
  }

  @override
  String? get _emailInputErrors => emailInputErrors;

  @override
  set _emailInputErrors(String? value) {
    _$_emailInputErrorsAtom.reportWrite(value, super._emailInputErrors, () {
      super._emailInputErrors = value;
    });
  }

  late final _$_passwordInputErrorsAtom = Atom(
      name: 'RegisterControllerBase._passwordInputErrors', context: context);

  String? get passwordInputErrors {
    _$_passwordInputErrorsAtom.reportRead();
    return super._passwordInputErrors;
  }

  @override
  String? get _passwordInputErrors => passwordInputErrors;

  @override
  set _passwordInputErrors(String? value) {
    _$_passwordInputErrorsAtom.reportWrite(value, super._passwordInputErrors,
        () {
      super._passwordInputErrors = value;
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
