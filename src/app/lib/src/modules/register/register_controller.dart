import "dart:developer";

import "package:mobx/mobx.dart";

import "package:sonorus/src/domain/exceptions/email_or_nickname_in_use_exception.dart";
import "package:sonorus/src/domain/exceptions/invalid_form_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/services/auth/auth_service.dart";

part "register_controller.g.dart";

enum RegisterPageStatus {
  initial,
  loading,
  success,
  error
}

class RegisterController = RegisterControllerBase with _$RegisterController;

abstract class RegisterControllerBase with Store {
  final AuthService _service;

  @readonly
  RegisterPageStatus _status = RegisterPageStatus.initial;

  @readonly
  String? _fullnameInputErrors;

  @readonly
  String? _nicknameInputErrors;

  @readonly
  String? _emailInputErrors;

  @readonly
  String? _passwordInputErrors;

  @readonly
  bool _showPassword = false;

  @readonly
  bool _showConfirmPassword = false;

  @readonly
  String? _error;
  
  RegisterControllerBase(this._service);

  @action
  void toggleShowPassword() => this._showPassword = !this._showPassword;

  @action
  void toggleShowConfirmPassword() => this._showConfirmPassword = !this._showConfirmPassword;

  @action
  Future<void> register(String fullname, String nickname, String email, String password) async {
    try {
      this._status = RegisterPageStatus.loading;

      await this._service.register(fullname, nickname, email, password);

      this._status = RegisterPageStatus.success;
    } on InvalidFormException catch (exception) {
      this._error = exception.message;
      this._fullnameInputErrors = exception.errorsByFieldName("fullname");
      this._nicknameInputErrors = exception.errorsByFieldName("nickname");
      this._emailInputErrors = exception.errorsByFieldName("email");
      this._passwordInputErrors = exception.errorsByFieldName("password");
      this._status = RegisterPageStatus.error;
    } on EmailOrNicknameInUseException catch (exception) {
      this._error = exception.message;
      this._status = RegisterPageStatus.error;
    } on RepositoryException catch (exception, stackTrace) {
      log("Erro ao registar o usuário", error: exception, stackTrace: stackTrace);
      this._error = exception.message;
      this._status = RegisterPageStatus.error;
    }
  }
}