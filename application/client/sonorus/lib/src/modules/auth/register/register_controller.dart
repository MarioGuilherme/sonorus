import "dart:developer";

import "package:mobx/mobx.dart";

import "package:sonorus/src/core/exceptions/email_or_nickname_in_use_exception.dart";
import "package:sonorus/src/core/exceptions/invalid_credentials_exception.dart";
import "package:sonorus/src/core/exceptions/repository_exception.dart";
import "package:sonorus/src/core/extensions/list_errors_extension.dart";
import "package:sonorus/src/services/auth/auth_service.dart";

part "register_controller.g.dart";

enum RegisterStateStatus {
  initial,
  loading,
  success,
  error
}

class RegisterController = RegisterControllerBase with _$RegisterController;

abstract class RegisterControllerBase with Store {
  final AuthService _authService;

  @readonly
  RegisterStateStatus _registerStatus = RegisterStateStatus.initial;

  @readonly
  String? _errorMessage;

  @readonly
  String? _fullnameInputErrors;

  @readonly
  String? _nicknameInputErrors;

  @readonly
  String? _emailInputErrors;

  @readonly
  String? _passwordInputErrors;
  
  RegisterControllerBase(this._authService);

  @action
  Future<void> register(String fullname, String nickname, String email, String password) async {
    try {
      this._registerStatus = RegisterStateStatus.loading;
      await this._authService.register(fullname, nickname, email, password);
      this._registerStatus = RegisterStateStatus.success;
    } on InvalidCredentialsException catch (exception, stackTrace) {
      log(exception.message, error: exception, stackTrace: stackTrace);
      this._errorMessage = exception.message;
      this._fullnameInputErrors = exception.errors.errorsByFieldName("fullname");
      this._nicknameInputErrors = exception.errors.errorsByFieldName("nickname");
      this._emailInputErrors = exception.errors.errorsByFieldName("email");
      this._passwordInputErrors = exception.errors.errorsByFieldName("password");
      this._registerStatus = RegisterStateStatus.error;
    } on EmailOrNicknameInUseException catch (exception, stackTrace) {
      log(exception.message, error: exception, stackTrace: stackTrace);
      this._errorMessage = exception.message;
      this._registerStatus = RegisterStateStatus.error;
    } on RepositoryException catch (exception, stackTrace) {
      log("Erro ao registar o usuário", error: exception, stackTrace: stackTrace);
      this._errorMessage = exception.message;
      this._registerStatus = RegisterStateStatus.error;
    }
  }
}