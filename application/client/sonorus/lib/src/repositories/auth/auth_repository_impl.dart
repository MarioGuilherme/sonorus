import "package:dio/dio.dart";
import "package:image_picker/image_picker.dart";

import "package:sonorus/src/core/exceptions/email_or_nickname_in_use_exception.dart";
import "package:sonorus/src/core/exceptions/invalid_credentials_exception.dart";
import "package:sonorus/src/core/exceptions/repository_exception.dart";
import "package:sonorus/src/core/exceptions/user_not_found_exception.dart";
import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/auth_token_model.dart";
import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/rest_response_model.dart";
import "package:sonorus/src/models/user_register_model.dart";
import "package:sonorus/src/repositories/auth/auth_repository.dart";

class AuthRepositoryImpl implements AuthRepository {
  final HttpClient _httpClient;

  AuthRepositoryImpl(this._httpClient);
  
  @override
  Future<AuthTokenModel> register(UserRegisterModel userRegisterModel) async {
    late final RestResponseModel restResponse;
    try {
      final Response result = await _httpClient.accountMS().unauth().post("/auth/register", data: userRegisterModel.toMap());
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return AuthTokenModel.fromMap(restResponse.data);
    } on DioException catch (exception) {
      restResponse = RestResponseModel.fromMap(exception.response!.data);

      if (exception.response?.statusCode == 400)
        throw InvalidCredentialsException(message: restResponse.message!, errors: restResponse.errors!);

      if (exception.response?.statusCode == 409)
        throw EmailOrNicknameInUseException(message: restResponse.message!);

      throw RepositoryException();
    }
  }

  @override
  Future<void> saveInterests(List<InterestModel> interests) async {
    try {
      final Response result = await _httpClient.accountMS().auth().post(
        "/users/interests",
        data: interests.map((interest) => <String, dynamic>{
          "interestId": interest.interestId,
          "key": interest.key,
          "value": interest.value,
          "type": interest.type.id
        }).toList()
      );
      if (result.statusCode != 204)
        throw Exception("Falha ao salvar os interesses do usuário");
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<String> savePicture(XFile file) async {
    try {
      final FormData formData = FormData.fromMap({ "picture": await MultipartFile.fromFile(file.path) });
      final Response result = await _httpClient.accountMS().auth().post("/users/picture", data: formData);
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data as String;
    } on DioException {
      throw RepositoryException();
    }
  }

  @override
  Future<AuthTokenModel> login(Map<String, String> data) async {
    late final RestResponseModel restResponse;
    try {
      final Response response = await _httpClient.accountMS().unauth().post("/auth/login", data: data);
      restResponse = RestResponseModel.fromMap(response.data);
      return AuthTokenModel.fromMap(restResponse.data);
    } on DioException catch (exception) {
      restResponse = RestResponseModel.fromMap(exception.response!.data);

      if (exception.response?.statusCode == 404)
        throw UserNotFoundException(message: restResponse.message!);

      if (exception.response?.statusCode == 400)
        throw InvalidCredentialsException(message: restResponse.message!, errors: restResponse.errors!);

      throw RepositoryException();
    }
  }

  @override
  Future<List<InterestModel>> getInterests() async {
    try {
      final Response result = await _httpClient.accountMS().unauth().get("/interests");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<InterestModel>((interest) => InterestModel.fromMap(interest)).toList();
    } on DioException {
      rethrow;
    }
  }
}