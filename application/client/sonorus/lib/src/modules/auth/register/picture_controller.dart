import "dart:developer";

import "package:flutter/services.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:image_picker/image_picker.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/core/exceptions/repository_exception.dart";
import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/repositories/auth/auth_repository.dart";

part "picture_controller.g.dart";

class PictureController = PictureControllerBase with _$PictureController;

enum PictureStateStatus {
  initial,
  loading,
  success,
  error
}

abstract class PictureControllerBase with Store {
  final AuthRepository _authRepository;

  @readonly
  PictureStateStatus _pictureStatus = PictureStateStatus.initial;

  @readonly
  XFile? _picture;

  @readonly
  Uint8List? _pictureBytes;

  @readonly
  String? _errorMessage;
  
  PictureControllerBase(this._authRepository);

  @action
  Future<void> changePictureUser(XFile picture) async {
    this._picture = picture;
    this._pictureBytes = await picture.readAsBytes();
  }

  @action
  void removePicture() => this._pictureBytes = null;

  @action
  Future<void> savePicture() async {
    try {
      this._pictureStatus = PictureStateStatus.loading;
      final String picturePath = await this._authRepository.savePicture(this._picture!);
      final CurrentUserModel currentUser = Modular.get<CurrentUserModel>();
      currentUser.setNewPicturePath(picturePath);
      this._pictureStatus = PictureStateStatus.success;
    } on RepositoryException catch (exception, stackTrace) {
      log("Erro ao salvar a foto do usuário", error: exception, stackTrace: stackTrace);
      this._errorMessage = "Tente novamente mais tarde";
      this._pictureStatus = PictureStateStatus.error;
    }
  }
}