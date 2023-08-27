import "dart:developer";

import "package:mobx/mobx.dart";
import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/repositories/auth/auth_repository.dart";

part "interests_controller.g.dart";

class InterestsController = InterestsControllerBase with _$InterestsController;

enum InterestStateStatus {
  initial,
  loading,
  success,
  error
}

abstract class InterestsControllerBase with Store {
  final AuthRepository _authRepository;

  @readonly
  InterestStateStatus _interestStatus = InterestStateStatus.initial;

  @readonly
  List<InterestModel> _interests = <InterestModel>[];
  
  @readonly
  // ignore: prefer_final_fields
  ObservableList<InterestModel> _selectedInterests = ObservableList<InterestModel>();

  @readonly
  String? _errorMessage;
  
  InterestsControllerBase(this._authRepository);

  @action
  Future<void> getAllInterests() async {
    try {
      this._interestStatus = InterestStateStatus.loading;
      this._interests = this._interests = await this._authRepository.getInterests();
      this._interestStatus = InterestStateStatus.success;
    } catch (e, s) {
      log("Erro ao obter os interesses de usuário", error: e, stackTrace: s);
      this._errorMessage = "Tente novamente mais tarde";
      this._interestStatus = InterestStateStatus.error;
    }
  }

  @action
  Future<void> addInterest(InterestModel interest) async {
    this._selectedInterests.add(interest);
  }

  @action
  Future<void> saveInterests() async {
    try {
      this._interestStatus = InterestStateStatus.loading;
      await this._authRepository.saveInterests(this._selectedInterests.toList());
      this._interestStatus = InterestStateStatus.success;
    } catch (e, s) {
      log("Erro ao salvar os interesses do usuário", error: e, stackTrace: s);
      this._errorMessage = "Tente novamente mais tarde";
      this._interestStatus = InterestStateStatus.error;
    }
  }
}