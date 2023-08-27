
import "package:dio/dio.dart";
import "package:image_picker/image_picker.dart";

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
    try {
      final Response result = await _httpClient.accountMicrosservice().unauth().post("/register", data: <String, String>{
        "fullname": fullname,
        "nickname": nickname,
        "email": email,
        "password": password
      });
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return AuthTokenModel.fromMap(restResponse.data);
    } on DioException {
      rethrow;
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
  Future<AuthTokenModel> login(String login, String password) async {
    try {
      final Response result = await _httpClient.accountMicrosservice().unauth().post("/login", data: <String, String>{
        "nickname": login,
        "email": login,
        "password": password
      });
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return AuthTokenModel.fromMap(restResponse.data);
      // return result.data!.data!;
      //
      // return AuthModel.fromMap(result.data);
    } on DioException {
      rethrow;
      // if (e.response?.statusCode == 403) {
      //   log("Permissão negada", error: e, stackTrace: s);
      //   throw UnauthorizedException();
      // }
      // log("Erro ao realizar login", error: e, stackTrace: s);
      // throw RepositoryException(message: "Erro ao realizar login");
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