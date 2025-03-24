import "package:dio/dio.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/domain/exceptions/authenticated_user_are_not_owner_of_opportunity_exception.dart";
import "package:sonorus/src/domain/exceptions/invalid_form_exception.dart";
import "package:sonorus/src/domain/exceptions/opportunity_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/dtos/input_models/opportunity_input_model.dart";
import "package:sonorus/src/dtos/view_models/opportunity_view_model.dart";
import "package:sonorus/src/repositories/opportunity/opportunity_repository.dart";

class OpportunityRepositoryImpl implements OpportunityRepository {
  final HttpClient _httpClient;

  OpportunityRepositoryImpl(this._httpClient);
  
  @override
  Future<OpportunityViewModel> createOpportunity(OpportunityInputModel inputModel) async {
    try {
      final Response result = await this._httpClient.auth().post("/opportunities", data: inputModel.toJson());
      return OpportunityViewModel.fromMap(result.data);
    } on Exception catch (exception) {
      if (exception is DioException)
        if (exception.response?.statusCode == 400) throw InvalidFormException.fromResponse(exception.response!);
      throw RepositoryException();
    }
  }

  @override
  Future<void> deleteByOpportunityId(int opportunityId) async {
    try {
      await this._httpClient.auth().delete("/opportunities/$opportunityId");
    } on Exception catch (exception) {
      if (exception is DioException) {
        if (exception.response?.statusCode == 403) throw AuthenticatedUserAreNotOwnerOfOpportunityException();
        if (exception.response?.statusCode == 404) throw OpportunityNotFoundException();
      }
      throw RepositoryException();
    }
  }

  @override
  Future<List<OpportunityViewModel>> getAllWithQuery(String? name) async {
    try {
      final Response result = await this._httpClient.auth().get("/opportunities${name == null ? "" : "?name=$name"}");
      return result.data.map<OpportunityViewModel>((opportunity) => OpportunityViewModel.fromMap(opportunity)).toList();
    } on Exception {
      throw RepositoryException();
    }
  }

  @override
  Future<OpportunityViewModel> updateOpportunity(int opportunityId, OpportunityInputModel inputModel) async {
    try {
      final Response result = await this._httpClient.auth().patch("/opportunities/$opportunityId", data: inputModel.toJson());
      return OpportunityViewModel.fromMap(result.data);
    } on Exception catch (exception) {
      if (exception is DioException) {
        if (exception.response?.statusCode == 400) throw InvalidFormException.fromResponse(exception.response!);
        if (exception.response?.statusCode == 403) throw AuthenticatedUserAreNotOwnerOfOpportunityException();
        if (exception.response?.statusCode == 404) throw OpportunityNotFoundException();
      }
      throw RepositoryException();
    }
  }
}