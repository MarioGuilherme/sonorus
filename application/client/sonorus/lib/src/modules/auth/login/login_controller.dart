import "dart:developer";

import "package:mobx/mobx.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:sonorus/src/models/auth_token_model.dart";

import "package:sonorus/src/repositories/auth/auth_repository.dart";

part "login_controller.g.dart";

enum LoginStateStatus {
  initial,
  loading,
  success,
  error
}

class LoginController = LoginControllerBase with _$LoginController;

abstract class LoginControllerBase with Store {
  final AuthRepository _authRepository;

  @readonly
  var _loginStatus = LoginStateStatus.initial;

  @readonly
  String? _errorMessage;

  LoginControllerBase(this._authRepository);

  @action
  Future<void> login(String login, String password) async {
    try {
      this._loginStatus = LoginStateStatus.loading;
      final AuthTokenModel authTokenModel = await this._authRepository.login(login, password);
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("accessToken", authTokenModel.accessToken!);
      sp.setString("refreshToken", authTokenModel.refreshToken!);
      this._loginStatus = LoginStateStatus.success;
    } catch (e, s) {
      log("Erro ao realizar login", error: e, stackTrace: s);
      _errorMessage = "Tente novamente mais tarde";
      _loginStatus = LoginStateStatus.error;
    }
  }
}