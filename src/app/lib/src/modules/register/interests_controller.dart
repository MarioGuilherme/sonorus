import "dart:developer";

import "package:mobx/mobx.dart";

import "package:sonorus/src/domain/enums/interest_type.dart";
import "package:sonorus/src/domain/exceptions/invalid_form_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/dtos/interest_dto.dart";
import "package:sonorus/src/services/interest/interest_service.dart";
import "package:sonorus/src/services/user/user_service.dart";

part "interests_controller.g.dart";

class InterestsController = InterestsControllerBase with _$InterestsController;

enum InterestsPageStatus {
  initial,
  savingInterests,
  loadingInterests,
  loadedInterests,
  savedInterests,
  error
}

abstract class InterestsControllerBase with Store {
  final UserService _userService;
  final InterestService _interestService;

  @readonly
  InterestsPageStatus _status = InterestsPageStatus.initial;

  @readonly
  ObservableList<InterestDto>? _interests;
  
  @readonly
  ObservableList<InterestDto> _selectedInterests = ObservableList<InterestDto>();

  @readonly
  String? _error;
  
  InterestsControllerBase(this._userService, this._interestService);

  @action
  void selectInterest(InterestDto interestSelected) => this._selectedInterests.any((i) => i.key == interestSelected.key)
    ? this._selectedInterests.remove(interestSelected)
    : this._selectedInterests.add(interestSelected);

  @action
  InterestDto addNewInterest(String key, String value, InterestType interestType) {
    final InterestDto newInterest = InterestDto(
      key: key,
      value: value,
      type: interestType
    );
    this._interests!.add(newInterest);
    this.selectInterest(newInterest);
    return newInterest;
  }

  @action
  Future<void> getAllInterests() async {
    try {
      this._status = InterestsPageStatus.loadingInterests;

      this._interests = ObservableList();
      this._interests!.addAll(await this._interestService.getAll());

      this._status = InterestsPageStatus.loadedInterests;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = InterestsPageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao buscar todos os interesses!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> saveInterests() async {
    try {
      this._status = InterestsPageStatus.savingInterests;

      await this._userService.associateCollectionOfInterests(this._selectedInterests.toList());

      this._status = InterestsPageStatus.savedInterests;
    } on InvalidFormException catch (exception) {
      this._status = InterestsPageStatus.error;
      this._error = exception.errorsConcatened;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = InterestsPageStatus.error;
      this._error = exception.message;
      log("Erro ao salvar os seus interesses!", error: exception, stackTrace: stackTrace);
    }
  }
}