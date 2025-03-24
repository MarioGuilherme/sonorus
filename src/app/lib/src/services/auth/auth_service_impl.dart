import "package:sonorus/src/core/utils/auth_utils.dart";
import "package:sonorus/src/dtos/input_models/create_user_input_model.dart";
import "package:sonorus/src/dtos/input_models/login_input_model.dart";
import "package:sonorus/src/dtos/input_models/refresh_token_input_model.dart";
import "package:sonorus/src/dtos/view_models/authenticated_user_view_model.dart";
import "package:sonorus/src/dtos/view_models/token_view_model.dart";
import "package:sonorus/src/repositories/auth/auth_repository.dart";
import "package:sonorus/src/services/auth/auth_service.dart";

class AuthServiceImpl implements AuthService {
  final AuthRepository _repository;

  AuthServiceImpl(this._repository);

  @override
  Future<bool> isAuthenticated() async {
    final (String? accessToken, String? refreshToken) = await AuthUtils.getAccessAndRefreshToken();
    if (accessToken != null && refreshToken != null) {
      final AuthenticatedUserViewModel authenticatedUserViewModel = await this._repository.getAuthenticatedUser();
      final TokenViewModel tokenViewModel = await this._repository.refreshToken(RefreshTokenInputModel(refreshToken: refreshToken));
      await AuthUtils.setAccessAndRefreshToken(tokenViewModel.accessToken, tokenViewModel.refreshToken);
      AuthUtils.startSession(tokenViewModel, authenticatedUserViewModel);
      return true;
    }
    return false;
  }

  @override
  Future<void> login(String login, String password) async {
    final LoginInputModel loginInputModel = LoginInputModel(login: login.trim(), password: password.trim());
    final TokenViewModel tokenViewModel = await this._repository.login(loginInputModel);

    await AuthUtils.setAccessAndRefreshToken(tokenViewModel.accessToken, tokenViewModel.refreshToken);
    final AuthenticatedUserViewModel authenticatedUserViewModel = await this._repository.getAuthenticatedUser();
    await AuthUtils.startSession(tokenViewModel, authenticatedUserViewModel);
  }

  @override
  Future<void> register(String fullname, String nickname, String email, String password) async {
    final CreateUserInputModel createUserInputModel = CreateUserInputModel(
      fullname: fullname.trim(),
      nickname: nickname.trim(),
      email: email.trim(),
      password: password.trim()
    );

    final TokenViewModel tokenViewModel = await this._repository.register(createUserInputModel);
    await AuthUtils.setAccessAndRefreshToken(tokenViewModel.accessToken, tokenViewModel.refreshToken);
    final AuthenticatedUserViewModel authenticatedUserViewModel = await this._repository.getAuthenticatedUser();
    await AuthUtils.startSession(tokenViewModel, authenticatedUserViewModel);
  }
}