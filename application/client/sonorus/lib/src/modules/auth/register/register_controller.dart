import "dart:developer";

import "package:image_picker/image_picker.dart";
import "package:mobx/mobx.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:sonorus/src/models/auth_token_model.dart";
import "package:sonorus/src/repositories/auth/auth_repository.dart";

part "register_controller.g.dart";

enum RegisterStateStatus {
  initial,
  loading,
  success,
  error
}

class RegisterController = RegisterControllerBase with _$RegisterController;

abstract class RegisterControllerBase with Store {
  final AuthRepository _authRepository;

  @readonly
  RegisterStateStatus _registerStatus = RegisterStateStatus.initial;

  @readonly
  String? _errorMessage;
  
  RegisterControllerBase(this._authRepository);

  @action
  Future<void> register(String fullname, String nickname, String email, String password) async {
    try {
      this._registerStatus = RegisterStateStatus.loading;
      final AuthTokenModel authTokenModel = await this._authRepository.register(fullname, nickname, email, password);
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("accessToken", authTokenModel.accessToken!);
      sp.setString("refreshToken", authTokenModel.refreshToken!);
      this._registerStatus = RegisterStateStatus.success;
    } catch (e, s) {
      log("Erro ao registar o usuário", error: e, stackTrace: s);
      _errorMessage = "Tente novamente mais tarde";
      _registerStatus = RegisterStateStatus.error;
    }
  }
}