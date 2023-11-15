import "package:dio/dio.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/opportunity_model.dart";
import "package:sonorus/src/models/rest_response_model.dart";
import "package:sonorus/src/repositories/business/business_repository.dart";

class BusinessRepositoryImpl implements BusinessRepository {
  final HttpClient _httpClient;

  BusinessRepositoryImpl(this._httpClient);

  @override
  Future<List<OpportunityModel>> getAllOpportunities() async {
    try {
      final Response result = await this._httpClient.businessMS().unauth().get("/opportunities");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<OpportunityModel>((opportunity) => OpportunityModel.fromMap(opportunity)).toList();
    } on DioException {
      rethrow;
    }
  }
  
  @override
  Future<void> deleteOpportunityById(int opportunityId) async {
    try {
      final Response result = await this._httpClient.businessMS().auth().delete("/opportunities/$opportunityId");
      if (result.statusCode != 204)
        throw Exception("Falha ao excluir a oportunidade");
    } on DioException {
      rethrow;
    }
  }
}