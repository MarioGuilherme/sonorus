// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserController on _UserControllerBase, Store {
  late final _$_userPageStatusAtom =
      Atom(name: '_UserControllerBase._userPageStatus', context: context);

  UserPageStateStatus get userPageStatus {
    _$_userPageStatusAtom.reportRead();
    return super._userPageStatus;
  }

  @override
  UserPageStateStatus get _userPageStatus => userPageStatus;

  @override
  set _userPageStatus(UserPageStateStatus value) {
    _$_userPageStatusAtom.reportWrite(value, super._userPageStatus, () {
      super._userPageStatus = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: '_UserControllerBase._errorMessage', context: context);

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

  late final _$_interestsAtom =
      Atom(name: '_UserControllerBase._interests', context: context);

  ObservableList<InterestModel> get interests {
    _$_interestsAtom.reportRead();
    return super._interests;
  }

  @override
  ObservableList<InterestModel> get _interests => interests;

  @override
  set _interests(ObservableList<InterestModel> value) {
    _$_interestsAtom.reportWrite(value, super._interests, () {
      super._interests = value;
    });
  }

  late final _$_userAtom =
      Atom(name: '_UserControllerBase._user', context: context);

  UserCompleteModel? get user {
    _$_userAtom.reportRead();
    return super._user;
  }

  @override
  UserCompleteModel? get _user => user;

  @override
  set _user(UserCompleteModel? value) {
    _$_userAtom.reportWrite(value, super._user, () {
      super._user = value;
    });
  }

  late final _$_currentPictureAtom =
      Atom(name: '_UserControllerBase._currentPicture', context: context);

  String? get currentPicture {
    _$_currentPictureAtom.reportRead();
    return super._currentPicture;
  }

  @override
  String? get _currentPicture => currentPicture;

  @override
  set _currentPicture(String? value) {
    _$_currentPictureAtom.reportWrite(value, super._currentPicture, () {
      super._currentPicture = value;
    });
  }

  late final _$_fullnameAtom =
      Atom(name: '_UserControllerBase._fullname', context: context);

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
      Atom(name: '_UserControllerBase._nickname', context: context);

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
      Atom(name: '_UserControllerBase._email', context: context);

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

  late final _$getUserDataAsyncAction =
      AsyncAction('_UserControllerBase.getUserData', context: context);

  @override
  Future<void> getUserData(int userId) {
    return _$getUserDataAsyncAction.run(() => super.getUserData(userId));
  }

  late final _$updateUserAsyncAction =
      AsyncAction('_UserControllerBase.updateUser', context: context);

  @override
  Future<void> updateUser(String fullname, String nickname, String email) {
    return _$updateUserAsyncAction
        .run(() => super.updateUser(fullname, nickname, email));
  }

  late final _$updatePictureAsyncAction =
      AsyncAction('_UserControllerBase.updatePicture', context: context);

  @override
  Future<void> updatePicture(XFile newPicture) {
    return _$updatePictureAsyncAction
        .run(() => super.updatePicture(newPicture));
  }

  late final _$updatePasswordAsyncAction =
      AsyncAction('_UserControllerBase.updatePassword', context: context);

  @override
  Future<void> updatePassword(String newPassword) {
    return _$updatePasswordAsyncAction
        .run(() => super.updatePassword(newPassword));
  }

  late final _$deleteMyAccountAsyncAction =
      AsyncAction('_UserControllerBase.deleteMyAccount', context: context);

  @override
  Future<void> deleteMyAccount() {
    return _$deleteMyAccountAsyncAction.run(() => super.deleteMyAccount());
  }

  late final _$getAllInterestsAsyncAction =
      AsyncAction('_UserControllerBase.getAllInterests', context: context);

  @override
  Future<void> getAllInterests() {
    return _$getAllInterestsAsyncAction.run(() => super.getAllInterests());
  }

  late final _$_UserControllerBaseActionController =
      ActionController(name: '_UserControllerBase', context: context);

  @override
  void setNewFields(String fullname, String nickname, String email) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setNewFields');
    try {
      return super.setNewFields(fullname, nickname, email);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addTagSelected(InterestModel interest) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.addTagSelected');
    try {
      return super.addTagSelected(interest);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTagSelected(InterestModel interest) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.removeTagSelected');
    try {
      return super.removeTagSelected(interest);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPicture(String newPicture) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setPicture');
    try {
      return super.setPicture(newPicture);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
