import "package:shared_preferences/shared_preferences.dart";

import "package:sonorus/src/models/auth_token_model.dart";
import "package:sonorus/src/repositories/auth/auth_repository.dart";
import "package:sonorus/src/services/auth/auth_service.dart";

class AuthServiceImpl implements AuthService {
  final AuthRepository _authRepository;

  AuthServiceImpl(this._authRepository);

  @override
  Future<void> login(String login, String password) async {
    final bool isEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(login);
    final AuthTokenModel authTokenModel = await this._authRepository.login({
      isEmail ? "email" : "nickname": login,
      "password": password
    });
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("accessToken", authTokenModel.accessToken!);
  }
  
  @override
  Future<void> register(String fullname, String nickname, String email, String password) async {
    final AuthTokenModel authTokenModel = await this._authRepository.register(fullname, nickname, email, password);
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("accessToken", authTokenModel.accessToken!);
  }
}