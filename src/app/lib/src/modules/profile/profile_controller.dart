// ignore_for_file: library_private_types_in_public_api, prefer_final_fields
import "dart:developer";
import "dart:math" show Random;

import "package:flutter_modular/flutter_modular.dart";
import "package:image_picker/image_picker.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/utils/auth_utils.dart";
import "package:sonorus/src/domain/exceptions/email_or_nickname_in_use_exception.dart";
import "package:sonorus/src/domain/exceptions/interest_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/invalid_form_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/domain/models/authenticated_user.dart";
import "package:sonorus/src/dtos/interest_dto.dart";
import "package:sonorus/src/services/interest/interest_service.dart";
import "package:sonorus/src/services/user/user_service.dart";

part "profile_controller.g.dart";

class ProfileController = _ProfileControllerBase with _$ProfileController;

enum ProfilePageStatus {
  initial,
  loadingMyInterests,
  loadedMyInterests,
  loadedAllInterests,
  loadingAllInterests,
  updatingUserData,
  updatedUserData,
  updatingPicture,
  updatedPicture,
  updatedPassword,
  updatingPassword,
  deletingUser,
  deletedUser,
  exiting,
  exited,
  error
}

abstract class _ProfileControllerBase with Store {
  final UserService _userService;
  final InterestService _interestService;

  @readonly
  ProfilePageStatus _status = ProfilePageStatus.initial;

  @readonly
  String? _picture;

  @readonly
  String? _fullname;

  @readonly
  String? _nickname;

  @readonly
  String? _email;

  @readonly
  ObservableList<InterestDto> _myInterests = ObservableList();

  @readonly
  ObservableList<InterestDto> _allInterests = ObservableList();

  @readonly
  String? _error;

  _ProfileControllerBase(this._userService, this._interestService);

  @action
  void setFieldsFromSession(AuthenticatedUser authenticatedUser) {
    this._fullname = authenticatedUser.fullname;
    this._nickname = authenticatedUser.nickname;
    this._email = authenticatedUser.email;
    this._picture = authenticatedUser.picture;
  }

  @action
  Future<void> associateInterest(InterestDto interest) async {
    try {
      this._myInterests.add(interest);
      await this._userService.associateInterest(interest.interestId);
    } on InterestNotFoundException catch (exception) {
      this._status = ProfilePageStatus.error;
      this._error = exception.message;
      this._myInterests.remove(interest);
    } on RepositoryException catch (exception, stackTrace) {
      this._status = ProfilePageStatus.error;
      this._error = exception.message;
      this._myInterests.remove(interest);
      log("Erro crítico ao associar o interesse ao usuário!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> disassociateInterest(InterestDto interest) async {
    try {
      this._myInterests.remove(interest);
      await this._userService.disassociateInterest(interest.interestId);
    } on InterestNotFoundException catch (exception) {
      this._status = ProfilePageStatus.error;
      this._error = exception.message;
      this._myInterests.add(interest);
    } on RepositoryException catch (exception, stackTrace) {
      this._status = ProfilePageStatus.error;
      this._error = exception.message;
      this._myInterests.add(interest);
      log("Erro crítico ao desassociar o interesse ao usuário!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> updatePicture(XFile picture) async {
    try {
      this._status = ProfilePageStatus.updatingPicture;

      this._picture = await this._userService.updatePicture(picture);
      this._picture = this._picture!.split("?").length == 1
        ? this._picture = "${this._picture}?v=${Random().nextInt(2)}"
        : this._picture = "${this._picture!.split("?").first}?v=${Random().nextInt(2)}";

      this._status = ProfilePageStatus.updatedPicture;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = ProfilePageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao atualizar a foto do usuário!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> updatePassword(String password) async {
    try {
      this._status = ProfilePageStatus.updatingPassword;

      await this._userService.updatePassword(password);

      this._status = ProfilePageStatus.updatedPassword;
    } on InvalidFormException catch (exception) {
      this._status = ProfilePageStatus.error;
      this._error = exception.errorsConcatened;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = ProfilePageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao atualizar a senha do usuário!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> deleteMyAccount() async {
    try {
      this._status = ProfilePageStatus.deletingUser;

      await this._userService.deleteMyAccount();
      await AuthUtils.clearSession();

      this._status = ProfilePageStatus.deletedUser;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = ProfilePageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao deletar o usuário!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> getMyInterests() async {
    try {
      this._status = ProfilePageStatus.loadingMyInterests;

      this._myInterests.clear();
      this._myInterests.addAll(await this._userService.getMyInterests());

      this._status = ProfilePageStatus.loadedMyInterests;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = ProfilePageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao buscar os interesses do usuário!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> signout() async {
    try {
      this._status = ProfilePageStatus.exiting;

      await AuthUtils.clearSession();

      this._status = ProfilePageStatus.exited;
    } on Exception catch (exception, stackTrace) {
      this._status = ProfilePageStatus.error;
      this._error = null;
      log("Erro crítico ao sair do aplicativo!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> showModalWithInterests() async {
    try {
      this._status = ProfilePageStatus.loadingAllInterests;

      this._allInterests.clear();
      this._allInterests.addAll(await this._interestService.getAll());

      this._status = ProfilePageStatus.loadedAllInterests;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = ProfilePageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao buscar todos os interesses!", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> updateUserData(String fullname, String nickname, String email) async {
    try {
      this._status = ProfilePageStatus.updatingUserData;

      await this._userService.updateUser(fullname, nickname, email);
      final AuthenticatedUser authenticatedUser = Modular.get<AuthenticatedUser>();
      this._fullname = fullname.trim();
      this._nickname = nickname.trim();
      this._email = email.trim();
      authenticatedUser.fullname = fullname.trim();
      authenticatedUser.nickname = nickname.trim();
      authenticatedUser.email = email.trim();

      this._status = ProfilePageStatus.updatedUserData;
    } on InvalidFormException catch (exception) {
      this._status = ProfilePageStatus.error;
      this._error = exception.errorsConcatened;
    } on EmailOrNicknameInUseException catch (exception) {
      this._status = ProfilePageStatus.error;
      this._error = exception.message;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = ProfilePageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao atualizar os dados do usuário!", error: exception, stackTrace: stackTrace);
    }
  }
}