import "package:dio/dio.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/domain/exceptions/email_or_nickname_in_use_exception.dart";
import "package:sonorus/src/domain/exceptions/invalid_form_exception.dart";
import "package:sonorus/src/domain/exceptions/refresh_token_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/domain/exceptions/user_not_found_exception.dart";
import "package:sonorus/src/dtos/input_models/create_user_input_model.dart";
import "package:sonorus/src/dtos/input_models/login_input_model.dart";
import "package:sonorus/src/dtos/input_models/refresh_token_input_model.dart";
import "package:sonorus/src/dtos/view_models/authenticated_user_view_model.dart";
import "package:sonorus/src/dtos/view_models/token_view_model.dart";
import "package:sonorus/src/repositories/auth/auth_repository.dart";

class AuthRepositoryImpl implements AuthRepository {
  final HttpClient _httpClient;

  AuthRepositoryImpl(this._httpClient);

  @override
  Future<TokenViewModel> login(LoginInputModel inputModel) async {
    try {
      final Response response = await this._httpClient.unauth().post("/auth/login", data: inputModel.toJson());
      return TokenViewModel.fromMap(response.data);
    } on Exception catch (exception) {
      if (exception is DioException) {
        if (exception.response?.statusCode == 400) throw InvalidFormException.fromResponse(exception.response!);
        if (exception.response?.statusCode == 404) throw UserNotFoundException();
      }
      throw RepositoryException();
    }
  }

  @override
  Future<AuthenticatedUserViewModel> getAuthenticatedUser() async {
    try {
      final Response result = await this._httpClient.auth().get("/users/me");
      return AuthenticatedUserViewModel.fromMap(result.data);
    } on Exception {
      throw RepositoryException();
    }
  }

  @override
  Future<TokenViewModel> refreshToken(RefreshTokenInputModel inputModel) async {
    try {
      final Response result = await this._httpClient.auth().put("/auth/refreshToken", data: inputModel.toJson());
      return TokenViewModel.fromMap(result.data);
    } on Exception catch (exception) {
      if (exception is DioException)
        if (exception.response?.statusCode == 404) throw RefreshTokenNotFoundException();
      throw RepositoryException();
    }
  }

  @override
  Future<TokenViewModel> register(CreateUserInputModel inputModel) async {
    try {
      final Response result = await this._httpClient.unauth().post("/auth/register", data: inputModel.toJson());
      return TokenViewModel.fromMap(result.data);
    } on Exception catch (exception) {
      if (exception is DioException) {
        if (exception.response?.statusCode == 400) throw InvalidFormException.fromResponse(exception.response!);
        if (exception.response?.statusCode == 409) throw EmailOrNicknameInUseException();
      }
      throw RepositoryException();
    }
  }
}