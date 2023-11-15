import "package:dio/dio.dart";
import "package:image_picker/image_picker.dart";
import "package:sonorus/src/core/exceptions/email_or_nickname_in_use_exception.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/rest_response_model.dart";
import "package:sonorus/src/models/user_complete_model.dart";
import "package:sonorus/src/repositories/user/user_repository.dart";

class UserRepositoryImpl implements UserRepository {
  final HttpClient _httpClient;

  UserRepositoryImpl(this._httpClient);

  @override
  Future<UserCompleteModel> getUserDataByUserId(int userId) async {
    try {
      final Response result = await _httpClient.accountMS().unauth().get("/users/$userId");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return UserCompleteModel.fromMap(restResponse.data);
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<void> deleteAccount(int userId) async {
    try {
      final Response result = await _httpClient.accountMS().auth().delete("/users/$userId");
      if (result.statusCode != 204)
        throw Exception("Falha ao excluir sua conta");
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<List<InterestModel>> getAllInterests() async {
    try {
      final Response result = await _httpClient.accountMS().auth().get("/users/interests");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<InterestModel>((post) => InterestModel.fromMap(post)).toList();
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      final Response result = await _httpClient.accountMS().auth().patch("/users", data: "\"$newPassword\"");
      if (result.statusCode != 204)
        throw Exception("Falha ao atualizar sua senha");
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<String> updatePicture(XFile newPicture) async {
    try {
      final FormData formData = FormData.fromMap({ "newPicture": await MultipartFile.fromFile(newPicture.path) });
      final Response result = await _httpClient.accountMS().auth().put("/users/picture", data: formData);
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data as String;
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<void> addInterest(int interestId) async {
    try {
      final Response result = await _httpClient.accountMS().auth().patch("/users/interests/$interestId");
      if (result.statusCode != 204)
        throw Exception("Falha ao adicionar seu novo interesse");
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<void> removeInterest(int interestId) async {
    try {
      final Response result = await _httpClient.accountMS().auth().delete("/users/interests/$interestId");
      if (result.statusCode != 204)
        throw Exception("Falha ao remover este interesse");
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<void> updateUser(String fullname, String nickname, String email) async {
    try {
      final Response result = await _httpClient.accountMS().auth().put("/users", data: {
        "fullname": fullname,
        "nickname": nickname,
        "email": email
      });
      if (result.statusCode == 409)
        throw EmailOrNicknameInUseException(message: "Este e-mail ou apelido já está em uso");
      if (result.statusCode != 204)
        throw Exception("Falha ao atualizar seus dados");
    } on DioException {
      rethrow;
    }
  }
}