// ignore_for_file: library_private_types_in_public_api

import "dart:developer";

import "package:mobx/mobx.dart";
import "package:sonorus/src/models/opportunity_model.dart";
import "package:sonorus/src/models/opportunity_model_register.dart";
import "package:sonorus/src/models/work_time_unit.dart";
import "package:sonorus/src/services/business/business_service.dart";
import "package:sonorus/src/services/creation/creation_service.dart";

part "business_controller.g.dart";

class BusinessController = _BusinessControllerBase with _$BusinessController;

enum BusinessStateStatus {
  initial,
  loadingOpportunities,
  loadedOpportunities,updatedOpportunity,
  updatingOpportunity,
  error
}

abstract class _BusinessControllerBase with Store {
  final BusinessService _businessService;
  final CreationService _creationService;

  @readonly
  bool _isWork = false;

  @readonly
  BusinessStateStatus _businessStatus = BusinessStateStatus.initial;

  @readonly
  String? _errorMessage;

  @readonly
  List<OpportunityModel> _opportunities = <OpportunityModel>[];

  _BusinessControllerBase(this._businessService, this._creationService);
  
  @action
  Future<void> getAllOpportunities() async {
    try {
      this._businessStatus = BusinessStateStatus.loadingOpportunities;
      this._opportunities = await this._businessService.getAllOpportunities();
      this._businessStatus = BusinessStateStatus.loadedOpportunities;
    }  on Exception catch (exception, stackTrace) {
      this._businessStatus = BusinessStateStatus.error;
      log("Erro ao buscar as oportunidades", error: exception, stackTrace: stackTrace);
    }
  }
  
  @action
  Future<void> filterByName(String name) async {
    try {
      this._businessStatus = BusinessStateStatus.loadingOpportunities;
      this._opportunities = await this._businessService.getAllOpportunitiesByName(name);
      this._businessStatus = BusinessStateStatus.loadedOpportunities;
    }  on Exception catch (exception, stackTrace) {
      this._businessStatus = BusinessStateStatus.error;
      log("Erro ao buscar os produtos", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> deleteOpportunityById(int opportunityId) async {
    try {
      await this._businessService.deleteOpportunityById(opportunityId);
    }  on Exception catch (exception, stackTrace) {
      log("Erro ao excluir a oportunidade", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  void toggleIsWork(bool value) => this._isWork = value;

  @action
  Future<void> updateOpportunity(int opportunityId, String name, String description, WorkTimeUnit idWork, String? bandName, String experience, double? payment, bool isToBand) async {
    try {
      this._businessStatus = BusinessStateStatus.updatingOpportunity;
      final OpportunityRegisterModel opportunity = OpportunityRegisterModel(
        opportunityId: opportunityId,
        experienceRequired: experience,
        isWork: !isToBand,
        name: name,
        bandName: bandName,
        description: description,
        payment: payment,
        workTimeUnit: idWork
      );
      await this._creationService.updateOpportunity(opportunity);
      this._businessStatus = BusinessStateStatus.updatedOpportunity;
    } on Exception catch (exception, stackTrace) {
      this._businessStatus = BusinessStateStatus.error;
      log("Erro ao criar anúncio", error: exception, stackTrace: stackTrace);
    }
  }
}