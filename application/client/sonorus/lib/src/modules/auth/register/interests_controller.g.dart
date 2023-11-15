// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interests_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InterestsController on InterestsControllerBase, Store {
  late final _$_interestStatusAtom =
      Atom(name: 'InterestsControllerBase._interestStatus', context: context);

  InterestStateStatus get interestStatus {
    _$_interestStatusAtom.reportRead();
    return super._interestStatus;
  }

  @override
  InterestStateStatus get _interestStatus => interestStatus;

  @override
  set _interestStatus(InterestStateStatus value) {
    _$_interestStatusAtom.reportWrite(value, super._interestStatus, () {
      super._interestStatus = value;
    });
  }

  late final _$_interestsAtom =
      Atom(name: 'InterestsControllerBase._interests', context: context);

  List<InterestModel>? get interests {
    _$_interestsAtom.reportRead();
    return super._interests;
  }

  @override
  List<InterestModel>? get _interests => interests;

  @override
  set _interests(List<InterestModel>? value) {
    _$_interestsAtom.reportWrite(value, super._interests, () {
      super._interests = value;
    });
  }

  late final _$_selectedInterestsAtom = Atom(
      name: 'InterestsControllerBase._selectedInterests', context: context);

  ObservableList<InterestModel> get selectedInterests {
    _$_selectedInterestsAtom.reportRead();
    return super._selectedInterests;
  }

  @override
  ObservableList<InterestModel> get _selectedInterests => selectedInterests;

  @override
  set _selectedInterests(ObservableList<InterestModel> value) {
    _$_selectedInterestsAtom.reportWrite(value, super._selectedInterests, () {
      super._selectedInterests = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: 'InterestsControllerBase._errorMessage', context: context);

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

  late final _$getAllInterestsAsyncAction =
      AsyncAction('InterestsControllerBase.getAllInterests', context: context);

  @override
  Future<void> getAllInterests() {
    return _$getAllInterestsAsyncAction.run(() => super.getAllInterests());
  }

  late final _$saveInterestsAsyncAction =
      AsyncAction('InterestsControllerBase.saveInterests', context: context);

  @override
  Future<void> saveInterests() {
    return _$saveInterestsAsyncAction.run(() => super.saveInterests());
  }

  late final _$InterestsControllerBaseActionController =
      ActionController(name: 'InterestsControllerBase', context: context);

  @override
  void selectInterest(InterestModel interestPressed) {
    final _$actionInfo = _$InterestsControllerBaseActionController.startAction(
        name: 'InterestsControllerBase.selectInterest');
    try {
      return super.selectInterest(interestPressed);
    } finally {
      _$InterestsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  InterestModel addNewInterest(
      String key, String value, InterestType interestType) {
    final _$actionInfo = _$InterestsControllerBaseActionController.startAction(
        name: 'InterestsControllerBase.addNewInterest');
    try {
      return super.addNewInterest(key, value, interestType);
    } finally {
      _$InterestsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
