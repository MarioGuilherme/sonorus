import "dart:developer";

import "package:flutter_modular/flutter_modular.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/utils/auth_utils.dart";
import "package:sonorus/src/domain/exceptions/invalid_form_exception.dart";
import "package:sonorus/src/domain/exceptions/refresh_token_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/domain/exceptions/user_not_found_exception.dart";
import "package:sonorus/src/services/auth/auth_service.dart";

part "login_controller.g.dart";

enum LoginPageStatus {
  initial,
  loading,
  success,
  error
}

class LoginController = LoginControllerBase with _$LoginController;

abstract class LoginControllerBase with Store {
  final AuthService _service;

  @readonly
  LoginPageStatus _status = LoginPageStatus.initial;

  @readonly
  String? _loginInputErrors;

  @readonly
  String? _passwordInputErrors;

  @readonly
  bool _showPassword = false;

  @readonly
  String? _error;

  LoginControllerBase(this._service);

  @action
  void toggleShowPassword() => this._showPassword = !this._showPassword;

  @action
  Future<void> login(String login, String password) async {
    try {
      this._status = LoginPageStatus.loading;

      await this._service.login(login, password);

      this._status = LoginPageStatus.success;
    } on UserNotFoundException catch (exception) {
      this._error = exception.message;
      this._loginInputErrors = null;
      this._passwordInputErrors = null;
      this._status = LoginPageStatus.error;
    } on InvalidFormException catch (exception) {
      this._error = exception.message;
      this._loginInputErrors = exception.errorsByFieldName("login");
      this._passwordInputErrors = exception.errorsByFieldName("password");
      this._status = LoginPageStatus.error;
    } on RepositoryException catch (exception, stackTrace) {
      log("Erro crítico ao realizar login", error: exception, stackTrace: stackTrace);
      this._error = exception.message;
      this._status = LoginPageStatus.error;
    }
  }

  @action
  Future<void> redirectIfAuthenticated() async {
    try {
      this._status = LoginPageStatus.loading;

      if (await this._service.isAuthenticated())
        Modular.to.navigate(Modular.initialRoute);

    } on RefreshTokenNotFoundException {
      await AuthUtils.clearSession();
    } on RepositoryException catch (exception, stackTrace) {
      log("Erro crítico ao verificar os tokens locais!", error: exception, stackTrace: stackTrace);
    }

    this._status = LoginPageStatus.error;
  }
}