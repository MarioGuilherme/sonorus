// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interests_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InterestsController on InterestsControllerBase, Store {
  late final _$_statusAtom =
      Atom(name: 'InterestsControllerBase._status', context: context);

  InterestsPageStatus get status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  InterestsPageStatus get _status => status;

  @override
  set _status(InterestsPageStatus value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
    });
  }

  late final _$_interestsAtom =
      Atom(name: 'InterestsControllerBase._interests', context: context);

  ObservableList<InterestDto>? get interests {
    _$_interestsAtom.reportRead();
    return super._interests;
  }

  @override
  ObservableList<InterestDto>? get _interests => interests;

  @override
  set _interests(ObservableList<InterestDto>? value) {
    _$_interestsAtom.reportWrite(value, super._interests, () {
      super._interests = value;
    });
  }

  late final _$_selectedInterestsAtom = Atom(
      name: 'InterestsControllerBase._selectedInterests', context: context);

  ObservableList<InterestDto> get selectedInterests {
    _$_selectedInterestsAtom.reportRead();
    return super._selectedInterests;
  }

  @override
  ObservableList<InterestDto> get _selectedInterests => selectedInterests;

  @override
  set _selectedInterests(ObservableList<InterestDto> value) {
    _$_selectedInterestsAtom.reportWrite(value, super._selectedInterests, () {
      super._selectedInterests = value;
    });
  }

  late final _$_errorAtom =
      Atom(name: 'InterestsControllerBase._error', context: context);

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
  void selectInterest(InterestDto interestSelected) {
    final _$actionInfo = _$InterestsControllerBaseActionController.startAction(
        name: 'InterestsControllerBase.selectInterest');
    try {
      return super.selectInterest(interestSelected);
    } finally {
      _$InterestsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  InterestDto addNewInterest(
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
