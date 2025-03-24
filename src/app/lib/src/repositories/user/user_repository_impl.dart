import "package:dio/dio.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/domain/exceptions/email_or_nickname_in_use_exception.dart";
import "package:sonorus/src/domain/exceptions/interest_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/invalid_form_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/dtos/input_models/associate_collection_of_interests_input_model.dart";
import "package:sonorus/src/dtos/input_models/save_user_picture_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_password_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_user_input_model.dart";
import "package:sonorus/src/dtos/interest_dto.dart";
import "package:sonorus/src/repositories/user/user_repository.dart";

class UserRepositoryImpl implements UserRepository {
  final HttpClient _httpClient;

  UserRepositoryImpl(this._httpClient);

  @override
  Future<void> associateCollectionOfInterests(AssociateCollectionOfInterestsInputModel inputModel) async {
    try {
      await this._httpClient.auth().post("/users/me/interests", data: inputModel.toJson());
    } on Exception catch (exception) {
      if (exception is DioException)
        if (exception.response?.statusCode == 400) throw InvalidFormException.fromResponse(exception.response!);
      throw RepositoryException();
    }
  }

  @override
  Future<void> associateInterest(int interestId) async {
    try {
      await this._httpClient.auth().post("/users/me/interests/$interestId");
    } on Exception catch (exception) {
      if (exception is DioException)
        if (exception.response?.statusCode == 404) throw InterestNotFoundException();
      throw RepositoryException();
    }
  }

  @override
  Future<void> deleteMyAccount() async {
    try {
      await this._httpClient.auth().delete("/users/me");
    } on Exception {
      throw RepositoryException();
    }
  }

  @override
  Future<void> disassociateInterest(int interestId) async {
    try {
      await this._httpClient.auth().delete("/users/me/interests/$interestId");
    } on Exception catch (exception) {
      if (exception is DioException)
        if (exception.response?.statusCode == 404) throw InterestNotFoundException();
      throw RepositoryException();
    }
  }

  @override
  Future<List<InterestDto>> getMyInterests() async {
    try {
      final Response result = await this._httpClient.auth().get("/users/me/interests");
      return result.data.map<InterestDto>((post) => InterestDto.fromMap(post)).toList();
    } on Exception {
      throw RepositoryException();
    }
  }

  @override
  Future<String> updatePicture(UpdateUserPictureInputModel inputModel) async {
    try {
      final Response result = await this._httpClient.auth().patch("/users/me/picture", data: inputModel.toFormData());
      return result.headers["location"]![0];
    } on Exception {
      throw RepositoryException();
    }
  }

  @override
  Future<void> updatePassword(UpdatePasswordInputModel inputModel) async {
    try {
      await this._httpClient.auth().patch("/users/me/password", data: inputModel.toJson());
    } on Exception catch (exception) {
      if (exception is DioException)
        if (exception.response?.statusCode == 400) throw InvalidFormException.fromResponse(exception.response!);
      throw RepositoryException();
    }
  }

  @override
  Future<void> updateUser(UpdateUserInputModel inputModel) async {
    try {
      await this._httpClient.auth().patch("/users/me", data: inputModel.toJson());
    } on Exception catch (exception) {
      if (exception is DioException) {
        if (exception.response?.statusCode == 400) throw InvalidFormException.fromResponse(exception.response!);
        if (exception.response?.statusCode == 409) throw EmailOrNicknameInUseException();
      }
      throw RepositoryException();
    }
  }
}