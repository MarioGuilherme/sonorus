// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginController on LoginControllerBase, Store {
  late final _$_statusAtom =
      Atom(name: 'LoginControllerBase._status', context: context);

  LoginPageStatus get status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  LoginPageStatus get _status => status;

  @override
  set _status(LoginPageStatus value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
    });
  }

  late final _$_loginInputErrorsAtom =
      Atom(name: 'LoginControllerBase._loginInputErrors', context: context);

  String? get loginInputErrors {
    _$_loginInputErrorsAtom.reportRead();
    return super._loginInputErrors;
  }

  @override
  String? get _loginInputErrors => loginInputErrors;

  @override
  set _loginInputErrors(String? value) {
    _$_loginInputErrorsAtom.reportWrite(value, super._loginInputErrors, () {
      super._loginInputErrors = value;
    });
  }

  late final _$_passwordInputErrorsAtom =
      Atom(name: 'LoginControllerBase._passwordInputErrors', context: context);

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
      Atom(name: 'LoginControllerBase._showPassword', context: context);

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

  late final _$_errorAtom =
      Atom(name: 'LoginControllerBase._error', context: context);

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

  late final _$loginAsyncAction =
      AsyncAction('LoginControllerBase.login', context: context);

  @override
  Future<void> login(String login, String password) {
    return _$loginAsyncAction.run(() => super.login(login, password));
  }

  late final _$redirectIfAuthenticatedAsyncAction = AsyncAction(
      'LoginControllerBase.redirectIfAuthenticated',
      context: context);

  @override
  Future<void> redirectIfAuthenticated() {
    return _$redirectIfAuthenticatedAsyncAction
        .run(() => super.redirectIfAuthenticated());
  }

  late final _$LoginControllerBaseActionController =
      ActionController(name: 'LoginControllerBase', context: context);

  @override
  void toggleShowPassword() {
    final _$actionInfo = _$LoginControllerBaseActionController.startAction(
        name: 'LoginControllerBase.toggleShowPassword');
    try {
      return super.toggleShowPassword();
    } finally {
      _$LoginControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
