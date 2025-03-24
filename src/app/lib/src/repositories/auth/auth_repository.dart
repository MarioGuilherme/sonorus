import "package:sonorus/src/dtos/input_models/create_user_input_model.dart";
import "package:sonorus/src/dtos/input_models/login_input_model.dart";
import "package:sonorus/src/dtos/input_models/refresh_token_input_model.dart";
import "package:sonorus/src/dtos/view_models/authenticated_user_view_model.dart";
import "package:sonorus/src/dtos/view_models/token_view_model.dart";

abstract interface class AuthRepository {
  Future<TokenViewModel> login(LoginInputModel inputModel);
  Future<AuthenticatedUserViewModel> getAuthenticatedUser();
  Future<TokenViewModel> refreshToken(RefreshTokenInputModel inputModel);
  Future<TokenViewModel> register(CreateUserInputModel inputModel);
}