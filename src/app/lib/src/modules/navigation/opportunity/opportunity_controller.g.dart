// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunity_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OpportunityController on _OpportunityControllerBase, Store {
  late final _$_statusAtom =
      Atom(name: '_OpportunityControllerBase._status', context: context);

  OpportunityPageStatus get status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  OpportunityPageStatus get _status => status;

  @override
  set _status(OpportunityPageStatus value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
    });
  }

  late final _$_opportunitiesAtom =
      Atom(name: '_OpportunityControllerBase._opportunities', context: context);

  ObservableList<OpportunityViewModel> get opportunities {
    _$_opportunitiesAtom.reportRead();
    return super._opportunities;
  }

  @override
  ObservableList<OpportunityViewModel> get _opportunities => opportunities;

  @override
  set _opportunities(ObservableList<OpportunityViewModel> value) {
    _$_opportunitiesAtom.reportWrite(value, super._opportunities, () {
      super._opportunities = value;
    });
  }

  late final _$_showFormAtom =
      Atom(name: '_OpportunityControllerBase._showForm', context: context);

  bool get showForm {
    _$_showFormAtom.reportRead();
    return super._showForm;
  }

  @override
  bool get _showForm => showForm;

  @override
  set _showForm(bool value) {
    _$_showFormAtom.reportWrite(value, super._showForm, () {
      super._showForm = value;
    });
  }

  late final _$_opportunityIdAtom =
      Atom(name: '_OpportunityControllerBase._opportunityId', context: context);

  int? get opportunityId {
    _$_opportunityIdAtom.reportRead();
    return super._opportunityId;
  }

  @override
  int? get _opportunityId => opportunityId;

  @override
  set _opportunityId(int? value) {
    _$_opportunityIdAtom.reportWrite(value, super._opportunityId, () {
      super._opportunityId = value;
    });
  }

  late final _$_isWorkAtom =
      Atom(name: '_OpportunityControllerBase._isWork', context: context);

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

  late final _$_workTimeUnitAtom =
      Atom(name: '_OpportunityControllerBase._workTimeUnit', context: context);

  WorkTimeUnit? get workTimeUnit {
    _$_workTimeUnitAtom.reportRead();
    return super._workTimeUnit;
  }

  @override
  WorkTimeUnit? get _workTimeUnit => workTimeUnit;

  @override
  set _workTimeUnit(WorkTimeUnit? value) {
    _$_workTimeUnitAtom.reportWrite(value, super._workTimeUnit, () {
      super._workTimeUnit = value;
    });
  }

  late final _$_savedOpportunityAtom = Atom(
      name: '_OpportunityControllerBase._savedOpportunity', context: context);

  OpportunityViewModel? get savedOpportunity {
    _$_savedOpportunityAtom.reportRead();
    return super._savedOpportunity;
  }

  @override
  OpportunityViewModel? get _savedOpportunity => savedOpportunity;

  @override
  set _savedOpportunity(OpportunityViewModel? value) {
    _$_savedOpportunityAtom.reportWrite(value, super._savedOpportunity, () {
      super._savedOpportunity = value;
    });
  }

  late final _$_errorAtom =
      Atom(name: '_OpportunityControllerBase._error', context: context);

  String? get error {
    _$_errorAtom.reportRead();
    return super._error;
  }

  @override
  String? get _error => error;

  @override
  set _error(String? value) {
    _$_errorAtom.reportWrite(value, super._error, () {
      super._error = value;
    });
  }

  late final _$getAllWithQueryAsyncAction = AsyncAction(
      '_OpportunityControllerBase.getAllWithQuery',
      context: context);

  @override
  Future<void> getAllWithQuery({String? name}) {
    return _$getAllWithQueryAsyncAction
        .run(() => super.getAllWithQuery(name: name));
  }

  late final _$saveOpportunityAsyncAction = AsyncAction(
      '_OpportunityControllerBase.saveOpportunity',
      context: context);

  @override
  Future<void> saveOpportunity(bool isUpdate, String name, String description,
      String? bandName, String experienceRequired, double payment) {
    return _$saveOpportunityAsyncAction.run(() => super.saveOpportunity(
        isUpdate, name, description, bandName, experienceRequired, payment));
  }

  late final _$deleteOpportunityByIdAsyncAction = AsyncAction(
      '_OpportunityControllerBase.deleteOpportunityById',
      context: context);

  @override
  Future<void> deleteOpportunityById(int opportunityId) {
    return _$deleteOpportunityByIdAsyncAction
        .run(() => super.deleteOpportunityById(opportunityId));
  }

  late final _$_OpportunityControllerBaseActionController =
      ActionController(name: '_OpportunityControllerBase', context: context);

  @override
  void toggleShowForm(bool? showForm) {
    final _$actionInfo = _$_OpportunityControllerBaseActionController
        .startAction(name: '_OpportunityControllerBase.toggleShowForm');
    try {
      return super.toggleShowForm(showForm);
    } finally {
      _$_OpportunityControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOpportunityId(int? opportunityId) {
    final _$actionInfo = _$_OpportunityControllerBaseActionController
        .startAction(name: '_OpportunityControllerBase.setOpportunityId');
    try {
      return super.setOpportunityId(opportunityId);
    } finally {
      _$_OpportunityControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleIsWork({bool? isWork}) {
    final _$actionInfo = _$_OpportunityControllerBaseActionController
        .startAction(name: '_OpportunityControllerBase.toggleIsWork');
    try {
      return super.toggleIsWork(isWork: isWork);
    } finally {
      _$_OpportunityControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setWorkTimeUnit(WorkTimeUnit? workTimeUnit) {
    final _$actionInfo = _$_OpportunityControllerBaseActionController
        .startAction(name: '_OpportunityControllerBase.setWorkTimeUnit');
    try {
      return super.setWorkTimeUnit(workTimeUnit);
    } finally {
      _$_OpportunityControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeSavedOpportunity() {
    final _$actionInfo = _$_OpportunityControllerBaseActionController
        .startAction(name: '_OpportunityControllerBase.removeSavedOpportunity');
    try {
      return super.removeSavedOpportunity();
    } finally {
      _$_OpportunityControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
