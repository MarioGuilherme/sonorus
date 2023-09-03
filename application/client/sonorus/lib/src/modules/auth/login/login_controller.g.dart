// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginController on LoginControllerBase, Store {
  late final _$_loginStatusAtom =
      Atom(name: 'LoginControllerBase._loginStatus', context: context);

  LoginStateStatus get loginStatus {
    _$_loginStatusAtom.reportRead();
    return super._loginStatus;
  }

  @override
  LoginStateStatus get _loginStatus => loginStatus;

  @override
  set _loginStatus(LoginStateStatus value) {
    _$_loginStatusAtom.reportWrite(value, super._loginStatus, () {
      super._loginStatus = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: 'LoginControllerBase._errorMessage', context: context);

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

  late final _$loginAsyncAction =
      AsyncAction('LoginControllerBase.login', context: context);

  @override
  Future<void> login(String login, String password) {
    return _$loginAsyncAction.run(() => super.login(login, password));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
