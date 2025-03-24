// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegisterController on RegisterControllerBase, Store {
  late final _$_statusAtom =
      Atom(name: 'RegisterControllerBase._status', context: context);

  RegisterPageStatus get status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  RegisterPageStatus get _status => status;

  @override
  set _status(RegisterPageStatus value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
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

  late final _$_showPasswordAtom =
      Atom(name: 'RegisterControllerBase._showPassword', context: context);

  bool get showPassword {
    _$_showPasswordAtom.reportRead();
    return super._showPassword;
  }

  @override
  bool get _showPassword => showPassword;

  @override
  set _showPassword(bool value) {
    _$_showPasswordAtom.reportWrite(value, super._showPassword, () {
      super._showPassword = value;
    });
  }

  late final _$_showConfirmPasswordAtom = Atom(
      name: 'RegisterControllerBase._showConfirmPassword', context: context);

  bool get showConfirmPassword {
    _$_showConfirmPasswordAtom.reportRead();
    return super._showConfirmPassword;
  }

  @override
  bool get _showConfirmPassword => showConfirmPassword;

  @override
  set _showConfirmPassword(bool value) {
    _$_showConfirmPasswordAtom.reportWrite(value, super._showConfirmPassword,
        () {
      super._showConfirmPassword = value;
    });
  }

  late final _$_errorAtom =
      Atom(name: 'RegisterControllerBase._error', context: context);

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

  late final _$registerAsyncAction =
      AsyncAction('RegisterControllerBase.register', context: context);

  @override
  Future<void> register(
      String fullname, String nickname, String email, String password) {
    return _$registerAsyncAction
        .run(() => super.register(fullname, nickname, email, password));
  }

  late final _$RegisterControllerBaseActionController =
      ActionController(name: 'RegisterControllerBase', context: context);

  @override
  void toggleShowPassword() {
    final _$actionInfo = _$RegisterControllerBaseActionController.startAction(
        name: 'RegisterControllerBase.toggleShowPassword');
    try {
      return super.toggleShowPassword();
    } finally {
      _$RegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleShowConfirmPassword() {
    final _$actionInfo = _$RegisterControllerBaseActionController.startAction(
        name: 'RegisterControllerBase.toggleShowConfirmPassword');
    try {
      return super.toggleShowConfirmPassword();
    } finally {
      _$RegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
