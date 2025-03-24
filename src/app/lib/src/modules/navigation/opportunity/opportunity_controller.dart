// ignore_for_file: library_private_types_in_public_api
import "dart:developer";

import "package:flutter_modular/flutter_modular.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/domain/enums/work_time_unit.dart";
import "package:sonorus/src/domain/exceptions/authenticated_user_are_not_owner_of_opportunity_exception.dart";
import "package:sonorus/src/domain/exceptions/invalid_form_exception.dart";
import "package:sonorus/src/domain/exceptions/opportunity_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/dtos/view_models/opportunity_view_model.dart";
import "package:sonorus/src/services/opportunity/opportunity_service.dart";

part "opportunity_controller.g.dart";

class OpportunityController = _OpportunityControllerBase with _$OpportunityController;

enum OpportunityPageStatus {
  initial,
  loadingOpportunities,
  loadedOpportunities,
  savingOpportunity,
  savedOpportunity,
  deletingOpportunity,
  deletedOpportunity,
  error
}

abstract class _OpportunityControllerBase with Store {
  final OpportunityService _service;

  @readonly
  OpportunityPageStatus _status = OpportunityPageStatus.initial;

  @readonly
  ObservableList<OpportunityViewModel> _opportunities = ObservableList();

  @readonly
  bool _showForm = false;

  @readonly
  int? _opportunityId;

  @readonly
  bool _isWork = false;

  @readonly
  WorkTimeUnit? _workTimeUnit;

  @readonly
  OpportunityViewModel? _savedOpportunity;

  @readonly
  String? _error;

  _OpportunityControllerBase(this._service);

  @action
  void toggleShowForm(bool? showForm) => this._showForm = showForm ?? !this._showForm;

  @action
  void setOpportunityId(int? opportunityId) => this._opportunityId = opportunityId;

  @action
  void toggleIsWork({ bool? isWork }) => this._isWork = isWork ?? !this._isWork;

  @action
  void setWorkTimeUnit(WorkTimeUnit? workTimeUnit) => this._workTimeUnit = workTimeUnit;

  @action
  void removeSavedOpportunity() => this._savedOpportunity = null;
  
  @action
  Future<void> getAllWithQuery({ String? name }) async {
    try {
      this._status = OpportunityPageStatus.loadingOpportunities;

      this._opportunities.clear();
      this._opportunities.addAll(await this._service.getAllWithQuery(name));

      this._status = OpportunityPageStatus.loadedOpportunities;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = OpportunityPageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao buscar as oportunidades!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> saveOpportunity(bool isUpdate, String name, String description, String? bandName, String experienceRequired, double payment) async {
    try {
      this._status = OpportunityPageStatus.savingOpportunity;

      this._savedOpportunity = await this._service.saveOpportunity(
        isUpdate ? this._opportunityId : null,
        name,
        bandName,
        description,
        experienceRequired,
        payment,
        this._isWork,
        this._workTimeUnit
      );

      this._status = OpportunityPageStatus.savedOpportunity;
    } on InvalidFormException catch (exception) {
      this._status = OpportunityPageStatus.error;
      this._error = exception.errorsConcatened;
    } on AuthenticatedUserAreNotOwnerOfOpportunityException catch (exception) {
      this._status = OpportunityPageStatus.error;
      this._error = exception.message;
      this._showForm = false;
    } on OpportunityNotFoundException catch (exception) {
      this._status = OpportunityPageStatus.error;
      this._error = exception.message;
      this._showForm = false;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = OpportunityPageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao salvar oportunidade!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> deleteOpportunityById(int opportunityId) async {
    try {
      this._status = OpportunityPageStatus.deletingOpportunity;

      await this._service.deleteByOpportunityId(opportunityId);

      this._status = OpportunityPageStatus.deletedOpportunity;
    } on AuthenticatedUserAreNotOwnerOfOpportunityException catch (exception) {
      this._status = OpportunityPageStatus.error;
      this._error = exception.message;
      Modular.to.pop();
      Modular.to.pop();
    } on OpportunityNotFoundException catch (exception) {
      this._status = OpportunityPageStatus.error;
      this._error = exception.message;
      Modular.to.pop();
      Modular.to.pop();
    } on RepositoryException catch (exception, stackTrace) {
      this._status = OpportunityPageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao excluir a oportunidade $opportunityId!", error: exception, stackTrace: stackTrace);
    }
  }
}