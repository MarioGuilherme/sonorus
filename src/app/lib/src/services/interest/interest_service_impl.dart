import "package:sonorus/src/dtos/interest_dto.dart";
import "package:sonorus/src/repositories/interest/interest_repository.dart";
import "package:sonorus/src/services/interest/interest_service.dart";

class InterestServiceImpl implements InterestService {
  final InterestRepository _repository;

  InterestServiceImpl(this._repository);

  @override
  Future<List<InterestDto>> getAll() => this._repository.getAll();
}