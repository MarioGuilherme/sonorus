import "package:flutter_modular/flutter_modular.dart";
import "package:jwt_decoder/jwt_decoder.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:sonorus/src/models/auth_token_model.dart";
import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/models/user_register_model.dart";
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
    final CurrentUserModel currentUser = Modular.get<CurrentUserModel>();
    currentUser.setCurrentUser(JwtDecoder.decode(authTokenModel.accessToken!));
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("accessToken", authTokenModel.accessToken!);
  }

  @override
  Future<void> register(String fullname, String nickname, String email, String password) async {
    final AuthTokenModel authTokenModel = await this._authRepository.register(UserRegisterModel(
      email: email.trim(),
      fullName: fullname.trim(),
      nickname: nickname.trim(),
      password: password.trim()
    ));
    final CurrentUserModel currentUser = Modular.get<CurrentUserModel>();
    currentUser.setCurrentUser(JwtDecoder.decode(authTokenModel.accessToken!));
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("accessToken", authTokenModel.accessToken!);
  }
}