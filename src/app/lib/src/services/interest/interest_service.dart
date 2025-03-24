import "package:sonorus/src/dtos/interest_dto.dart";

abstract interface class InterestService {
  Future<List<InterestDto>> getAll();
}