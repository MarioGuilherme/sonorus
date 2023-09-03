
import "package:dio/dio.dart";
import "package:image_picker/image_picker.dart";
import "package:sonorus/src/core/exceptions/repository_exception.dart";
import "package:sonorus/src/core/exceptions/invalid_credentials_exception.dart";
import "package:sonorus/src/core/exceptions/user_not_found_exception.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/auth_token_model.dart";
import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/rest_response_model.dart";
import "package:sonorus/src/repositories/auth/auth_repository.dart";

class AuthRepositoryImpl implements AuthRepository {
  final HttpClient _httpClient;

  AuthRepositoryImpl(this._httpClient);
  
  @override
  Future<AuthTokenModel> register(String fullname, String nickname, String email, String password) async {
    late final RestResponseModel restResponse;
    try {
      final Response result = await _httpClient.accountMicrosservice().unauth().post("/auth/register", data: {
        "fullname": fullname,
        "nickname": nickname,
        "email": email,
        "password": password
      });
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return AuthTokenModel.fromMap(restResponse.data);
    } on DioException catch (exception) {
      restResponse = RestResponseModel.fromMap(exception.response!.data);

      if (exception.response?.statusCode == 400)
        throw InvalidCredentialsException(message: restResponse.message!, errors: restResponse.errors!);

      throw RepositoryException();
    }
  }

  @override
  Future<void> saveInterests(List<InterestModel> interests) async {
    try {
      final Response result = await _httpClient.accountMicrosservice().auth().post(
        "/saveInterests",
        data: interests.map((interest) => <String, dynamic>{
          "idInterest": interest.idInterest,
          "key": interest.key,
          "value": interest.value,
          "type": interest.type!.id
        }).toList()
      );
      if (result.statusCode != 204)
        throw Exception("Falha ao salvar os interesses do usuário");
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<void> savePicture(XFile file) async {
    try {
      final FormData formData = FormData.fromMap({ "picture": await MultipartFile.fromFile(file.path) });
      final Response result = await _httpClient.accountMicrosservice().auth().post("/savePicture", data: formData);
      if (result.statusCode != 204)
        throw Exception("Falha ao salvar imagem do usuário");
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<AuthTokenModel> login(Map<String, String> data) async {
    late final RestResponseModel restResponse;
    try {
      final Response response = await _httpClient.accountMicrosservice().unauth().post("/auth/login", data: data);
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
      final Response result = await _httpClient.accountMicrosservice().unauth().get("/interests");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<InterestModel>((interest) => InterestModel.fromMap(interest)).toList();
    } on DioException {
      rethrow;
    }
  }
}