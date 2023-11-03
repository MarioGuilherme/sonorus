import "dart:developer";

import "package:mobx/mobx.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:sonorus/src/core/exceptions/invalid_credentials_exception.dart";
import "package:sonorus/src/core/exceptions/repository_exception.dart";
import "package:sonorus/src/core/exceptions/user_not_found_exception.dart";
import "package:sonorus/src/core/extensions/list_errors.dart";
import "package:sonorus/src/services/auth/auth_service.dart";

part "login_controller.g.dart";

enum LoginStateStatus {
  initial,
  loading,
  success,
  error
}

class LoginController = LoginControllerBase with _$LoginController;

abstract class LoginControllerBase with Store {
  final AuthService _authService;

  @readonly
  LoginStateStatus _loginStatus = LoginStateStatus.initial;

  @readonly
  String? _errorMessage;

  @readonly
  String? _loginInputErrors;

  @readonly
  String? _passwordInputErrors;

  LoginControllerBase(this._authService);

  @action
  Future<void> login(String login, String password) async {
    try {
      this._loginStatus = LoginStateStatus.loading;
      await this._authService.login(login, password);
      this._loginStatus = LoginStateStatus.success;
    } on UserNotFoundException catch (exception, stackTrace) {
      log(exception.message, error: exception, stackTrace: stackTrace);
      this._errorMessage = exception.message;
      this._loginInputErrors = null;
      this._passwordInputErrors = null;
      this._loginStatus = LoginStateStatus.error;
    } on InvalidCredentialsException catch (exception, stackTrace) {
      log(exception.message, error: exception, stackTrace: stackTrace);
      this._errorMessage = exception.message;
      this._loginInputErrors = exception.errors.errorsByFieldName("login");
      this._passwordInputErrors = exception.errors.errorsByFieldName("password");
      this._loginStatus = LoginStateStatus.error;
    } on RepositoryException catch (exception, stackTrace) {
      log("Erro ao realizar login", error: exception, stackTrace: stackTrace);
      this._errorMessage = exception.message;
      this._loginStatus = LoginStateStatus.error;
    }
  }

  @action
  Future<bool> isAuthenticated() async {
    try {
      return await this._authService.isAuthenticated();
    } on Exception {
      // log("Erro ao realizar login", error: exception, stackTrace: stackTrace);
      // // this._errorMessage = exception.message;
      // this._loginStatus = LoginStateStatus.error;
      return false;
    }
  }
}