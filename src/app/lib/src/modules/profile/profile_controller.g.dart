// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileController on _ProfileControllerBase, Store {
  late final _$_statusAtom =
      Atom(name: '_ProfileControllerBase._status', context: context);

  ProfilePageStatus get status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  ProfilePageStatus get _status => status;

  @override
  set _status(ProfilePageStatus value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
    });
  }

  late final _$_pictureAtom =
      Atom(name: '_ProfileControllerBase._picture', context: context);

  String? get picture {
    _$_pictureAtom.reportRead();
    return super._picture;
  }

  @override
  String? get _picture => picture;

  @override
  set _picture(String? value) {
    _$_pictureAtom.reportWrite(value, super._picture, () {
      super._picture = value;
    });
  }

  late final _$_fullnameAtom =
      Atom(name: '_ProfileControllerBase._fullname', context: context);

  String? get fullname {
    _$_fullnameAtom.reportRead();
    return super._fullname;
  }

  @override
  String? get _fullname => fullname;

  @override
  set _fullname(String? value) {
    _$_fullnameAtom.reportWrite(value, super._fullname, () {
      super._fullname = value;
    });
  }

  late final _$_nicknameAtom =
      Atom(name: '_ProfileControllerBase._nickname', context: context);

  String? get nickname {
    _$_nicknameAtom.reportRead();
    return super._nickname;
  }

  @override
  String? get _nickname => nickname;

  @override
  set _nickname(String? value) {
    _$_nicknameAtom.reportWrite(value, super._nickname, () {
      super._nickname = value;
    });
  }

  late final _$_emailAtom =
      Atom(name: '_ProfileControllerBase._email', context: context);

  String? get email {
    _$_emailAtom.reportRead();
    return super._email;
  }

  @override
  String? get _email => email;

  @override
  set _email(String? value) {
    _$_emailAtom.reportWrite(value, super._email, () {
      super._email = value;
    });
  }

  late final _$_myInterestsAtom =
      Atom(name: '_ProfileControllerBase._myInterests', context: context);

  ObservableList<InterestDto> get myInterests {
    _$_myInterestsAtom.reportRead();
    return super._myInterests;
  }

  @override
  ObservableList<InterestDto> get _myInterests => myInterests;

  @override
  set _myInterests(ObservableList<InterestDto> value) {
    _$_myInterestsAtom.reportWrite(value, super._myInterests, () {
      super._myInterests = value;
    });
  }

  late final _$_allInterestsAtom =
      Atom(name: '_ProfileControllerBase._allInterests', context: context);

  ObservableList<InterestDto> get allInterests {
    _$_allInterestsAtom.reportRead();
    return super._allInterests;
  }

  @override
  ObservableList<InterestDto> get _allInterests => allInterests;

  @override
  set _allInterests(ObservableList<InterestDto> value) {
    _$_allInterestsAtom.reportWrite(value, super._allInterests, () {
      super._allInterests = value;
    });
  }

  late final _$_errorAtom =
      Atom(name: '_ProfileControllerBase._error', context: context);

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

  late final _$associateInterestAsyncAction =
      AsyncAction('_ProfileControllerBase.associateInterest', context: context);

  @override
  Future<void> associateInterest(InterestDto interest) {
    return _$associateInterestAsyncAction
        .run(() => super.associateInterest(interest));
  }

  late final _$disassociateInterestAsyncAction = AsyncAction(
      '_ProfileControllerBase.disassociateInterest',
      context: context);

  @override
  Future<void> disassociateInterest(InterestDto interest) {
    return _$disassociateInterestAsyncAction
        .run(() => super.disassociateInterest(interest));
  }

  late final _$updatePictureAsyncAction =
      AsyncAction('_ProfileControllerBase.updatePicture', context: context);

  @override
  Future<void> updatePicture(XFile picture) {
    return _$updatePictureAsyncAction.run(() => super.updatePicture(picture));
  }

  late final _$updatePasswordAsyncAction =
      AsyncAction('_ProfileControllerBase.updatePassword', context: context);

  @override
  Future<void> updatePassword(String password) {
    return _$updatePasswordAsyncAction
        .run(() => super.updatePassword(password));
  }

  late final _$deleteMyAccountAsyncAction =
      AsyncAction('_ProfileControllerBase.deleteMyAccount', context: context);

  @override
  Future<void> deleteMyAccount() {
    return _$deleteMyAccountAsyncAction.run(() => super.deleteMyAccount());
  }

  late final _$getMyInterestsAsyncAction =
      AsyncAction('_ProfileControllerBase.getMyInterests', context: context);

  @override
  Future<void> getMyInterests() {
    return _$getMyInterestsAsyncAction.run(() => super.getMyInterests());
  }

  late final _$signoutAsyncAction =
      AsyncAction('_ProfileControllerBase.signout', context: context);

  @override
  Future<void> signout() {
    return _$signoutAsyncAction.run(() => super.signout());
  }

  late final _$showModalWithInterestsAsyncAction = AsyncAction(
      '_ProfileControllerBase.showModalWithInterests',
      context: context);

  @override
  Future<void> showModalWithInterests() {
    return _$showModalWithInterestsAsyncAction
        .run(() => super.showModalWithInterests());
  }

  late final _$updateUserDataAsyncAction =
      AsyncAction('_ProfileControllerBase.updateUserData', context: context);

  @override
  Future<void> updateUserData(String fullname, String nickname, String email) {
    return _$updateUserDataAsyncAction
        .run(() => super.updateUserData(fullname, nickname, email));
  }

  late final _$_ProfileControllerBaseActionController =
      ActionController(name: '_ProfileControllerBase', context: context);

  @override
  void setFieldsFromSession(AuthenticatedUser authenticatedUser) {
    final _$actionInfo = _$_ProfileControllerBaseActionController.startAction(
        name: '_ProfileControllerBase.setFieldsFromSession');
    try {
      return super.setFieldsFromSession(authenticatedUser);
    } finally {
      _$_ProfileControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
