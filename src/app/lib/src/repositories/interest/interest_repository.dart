import "package:sonorus/src/dtos/interest_dto.dart";

abstract interface class InterestRepository {
  Future<List<InterestDto>> getAll();
}