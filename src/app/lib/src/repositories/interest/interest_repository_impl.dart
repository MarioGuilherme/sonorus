import "package:dio/dio.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/dtos/interest_dto.dart";
import "package:sonorus/src/repositories/interest/interest_repository.dart";

class InterestRepositoryImpl implements InterestRepository {
  final HttpClient _httpClient;

  InterestRepositoryImpl(this._httpClient);

  @override
  Future<List<InterestDto>> getAll() async {
    try {
      final Response result = await this._httpClient.unauth().get("/interests");
      return result.data.map<InterestDto>((interest) => InterestDto.fromMap(interest)).toList();
    } on Exception {
      throw RepositoryException();
    }
  }
}