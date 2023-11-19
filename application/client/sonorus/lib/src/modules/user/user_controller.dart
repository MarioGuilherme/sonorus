import "dart:developer";

import "package:image_picker/image_picker.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/user_complete_model.dart";
import "package:sonorus/src/services/user/user_service.dart";

part "user_controller.g.dart";

class UserController = _UserControllerBase with _$UserController;

enum UserPageStateStatus {
  initial,
  loadingUser,
  savingUserData,
  loadedUser,
  savedUserData,
  error
}

abstract class _UserControllerBase with Store {
  final UserService _userService;

  @readonly
  UserPageStateStatus _userPageStatus = UserPageStateStatus.initial;

  @readonly
  String? _errorMessage;

  @readonly
  // ignore: prefer_final_fields
  ObservableList<InterestModel> _interests = ObservableList<InterestModel>();

  @readonly
  UserCompleteModel? _user;

  _UserControllerBase(this._userService);

  @readonly
  String? _currentPicture;
  @readonly
  String? _fullname;
  @readonly
  String? _nickname;
  @readonly
  String? _email;

  @action
  void setNewFields(String fullname, String nickname, String email) {
    this._fullname = fullname;
    this._nickname = nickname;
    this._email = email;
  }

  @action
  void addTagSelected(InterestModel interest) {
    this._userService.addInterest(interest.interestId!);
    this._interests.add(interest);
  }

  @action
  Future<void> getUserData(int userId) async {
    try {
      this._userPageStatus = UserPageStateStatus.loadingUser;
      this._user = await this._userService.getUserDataByUserId(userId);
      this._userPageStatus = UserPageStateStatus.loadedUser;
    } on Exception catch (exception, stackTrace) {
      log("Erro ao buscar os dados deste usuário", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> updateUser(String fullname, String nickname, String email) async {
    await this._userService.updateUser(fullname, nickname, email);
  }

  @action
  void removeTagSelected(InterestModel interest) {
    this._userService.removeInterest(interest.interestId!);
    this._interests.remove(interest);
  }

  @action
  Future<void> updatePicture(XFile newPicture) async {
    this._currentPicture = await this._userService.updatePicture(newPicture);
  }
  @action
  void setPicture(String newPicture) {
    this._currentPicture = newPicture;
  }

  @action
  Future<void> updatePassword(String newPassword) async {
    await this._userService.updatePassword(newPassword);
  }

  @action
  Future<void> deleteMyAccount() async {
    await this._userService.deleteMyAccount();
  }

  @action
  Future<void> getAllInterests() async {
    this._userPageStatus = UserPageStateStatus.loadingUser;
    this._interests.clear();
    this._interests.addAll(await this._userService.getAllInterests());
    this._userPageStatus = UserPageStateStatus.loadedUser;
  }
}