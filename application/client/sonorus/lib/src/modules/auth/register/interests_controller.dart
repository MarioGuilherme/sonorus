import "dart:developer";

import "package:mobx/mobx.dart";

import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/interest_type.dart";
import "package:sonorus/src/repositories/auth/auth_repository.dart";

part "interests_controller.g.dart";

class InterestsController = InterestsControllerBase with _$InterestsController;

enum InterestStateStatus {
  initial,
  savingInterests,
  loadingInterests,
  loadedInterests,
  savedInterests,
  error
}

abstract class InterestsControllerBase with Store {
  final AuthRepository _authRepository;

  @readonly
  InterestStateStatus _interestStatus = InterestStateStatus.initial;

  @readonly
  List<InterestModel>? _interests;
  
  @readonly
  // ignore: prefer_final_fields
  ObservableList<InterestModel> _selectedInterests = ObservableList<InterestModel>();

  @readonly
  String? _errorMessage;
  
  InterestsControllerBase(this._authRepository);

  @action
  Future<void> getAllInterests() async {
    try {
      this._interestStatus = InterestStateStatus.loadingInterests;
      this._interests = <InterestModel>[];
      this._interests = this._interests = await this._authRepository.getInterests();
      this._interestStatus = InterestStateStatus.loadedInterests;
    } catch (e, s) {
      log("Erro ao buscar os interesses do servidor", error: e, stackTrace: s);
      this._errorMessage = "Erro ao buscar os interesses do servidor, por favor, tente novamente mais tarde";
      this._interestStatus = InterestStateStatus.error;
    }
  }

  @action
  void selectInterest(InterestModel interestPressed) {
    if (this._selectedInterests.any((i) => i.interestId == interestPressed.interestId)) {
      this._selectedInterests.remove(interestPressed);
      if (interestPressed.interestId == null)
        this._interests!.removeWhere((interest) => interestPressed.key == interest.key);
    } else {
      this._selectedInterests.add(interestPressed);
    }
  }

  @action
  InterestModel addNewInterest(String key, String value, InterestType interestType) {
    final InterestModel newInterest = InterestModel(
      key: key,
      value: value,
      type: interestType
    );
    this._interests!.add(newInterest);
    return newInterest;
  }

  @action
  Future<void> saveInterests() async {
    try {
      if (this._selectedInterests.isEmpty) {
        
      }
      this._interestStatus = InterestStateStatus.savingInterests;
      await this._authRepository.saveInterests(this._selectedInterests.toList());
      this._interestStatus = InterestStateStatus.savedInterests;
    } catch (e, s) {
      log("Erro ao salvar os interesses do usuário", error: e, stackTrace: s);
      this._errorMessage = "Tente novamente mais tarde";
      this._interestStatus = InterestStateStatus.error;
    }
  }
}