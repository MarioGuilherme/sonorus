// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BusinessController on _BusinessControllerBase, Store {
  late final _$_isWorkAtom =
      Atom(name: '_BusinessControllerBase._isWork', context: context);

  bool get isWork {
    _$_isWorkAtom.reportRead();
    return super._isWork;
  }

  @override
  bool get _isWork => isWork;

  @override
  set _isWork(bool value) {
    _$_isWorkAtom.reportWrite(value, super._isWork, () {
      super._isWork = value;
    });
  }

  late final _$_businessStatusAtom =
      Atom(name: '_BusinessControllerBase._businessStatus', context: context);

  BusinessStateStatus get businessStatus {
    _$_businessStatusAtom.reportRead();
    return super._businessStatus;
  }

  @override
  BusinessStateStatus get _businessStatus => businessStatus;

  @override
  set _businessStatus(BusinessStateStatus value) {
    _$_businessStatusAtom.reportWrite(value, super._businessStatus, () {
      super._businessStatus = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: '_BusinessControllerBase._errorMessage', context: context);

  String? get errorMessage {
    _$_errorMessageAtom.reportRead();
    return super._errorMessage;
  }

  @override
  String? get _errorMessage => errorMessage;

  @override
  set _errorMessage(String? value) {
    _$_errorMessageAtom.reportWrite(value, super._errorMessage, () {
      super._errorMessage = value;
    });
  }

  late final _$_opportunitiesAtom =
      Atom(name: '_BusinessControllerBase._opportunities', context: context);

  List<OpportunityModel> get opportunities {
    _$_opportunitiesAtom.reportRead();
    return super._opportunities;
  }

  @override
  List<OpportunityModel> get _opportunities => opportunities;

  @override
  set _opportunities(List<OpportunityModel> value) {
    _$_opportunitiesAtom.reportWrite(value, super._opportunities, () {
      super._opportunities = value;
    });
  }

  late final _$getAllOpportunitiesAsyncAction = AsyncAction(
      '_BusinessControllerBase.getAllOpportunities',
      context: context);

  @override
  Future<void> getAllOpportunities() {
    return _$getAllOpportunitiesAsyncAction
        .run(() => super.getAllOpportunities());
  }

  late final _$filterByNameAsyncAction =
      AsyncAction('_BusinessControllerBase.filterByName', context: context);

  @override
  Future<void> filterByName(String name) {
    return _$filterByNameAsyncAction.run(() => super.filterByName(name));
  }

  late final _$deleteOpportunityByIdAsyncAction = AsyncAction(
      '_BusinessControllerBase.deleteOpportunityById',
      context: context);

  @override
  Future<void> deleteOpportunityById(int opportunityId) {
    return _$deleteOpportunityByIdAsyncAction
        .run(() => super.deleteOpportunityById(opportunityId));
  }

  late final _$updateOpportunityAsyncAction = AsyncAction(
      '_BusinessControllerBase.updateOpportunity',
      context: context);

  @override
  Future<void> updateOpportunity(
      int opportunityId,
      String name,
      String description,
      WorkTimeUnit idWork,
      String? bandName,
      String experience,
      double? payment,
      bool isToBand) {
    return _$updateOpportunityAsyncAction.run(() => super.updateOpportunity(
        opportunityId,
        name,
        description,
        idWork,
        bandName,
        experience,
        payment,
        isToBand));
  }

  late final _$_BusinessControllerBaseActionController =
      ActionController(name: '_BusinessControllerBase', context: context);

  @override
  void toggleIsWork(bool value) {
    final _$actionInfo = _$_BusinessControllerBaseActionController.startAction(
        name: '_BusinessControllerBase.toggleIsWork');
    try {
      return super.toggleIsWork(value);
    } finally {
      _$_BusinessControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
