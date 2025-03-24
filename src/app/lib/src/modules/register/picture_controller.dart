import "dart:developer";

import "package:flutter/services.dart";
import "package:image_picker/image_picker.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/services/user/user_service.dart";

part "picture_controller.g.dart";

class PictureController = PictureControllerBase with _$PictureController;

enum PicturePageState {
  initial,
  savingPicture,
  savedPicture,
  error
}

abstract class PictureControllerBase with Store {
  final UserService _service;

  @readonly
  PicturePageState _status = PicturePageState.initial;

  @readonly
  XFile? _picture;

  @readonly
  Uint8List? _pictureBytes;

  @readonly
  String? _error;
  
  PictureControllerBase(this._service);

  @action
  void removePicture() => this._pictureBytes = null;

  @action
  Future<void> changePictureUser(XFile picture) async {
    this._picture = picture;
    this._pictureBytes = await picture.readAsBytes();
  }

  @action
  Future<void> updatePicture() async {
    try {
      this._status = PicturePageState.savingPicture;

      await this._service.updatePicture(this._picture!);

      this._status = PicturePageState.savedPicture;
    } on RepositoryException catch (exception, stackTrace) {
      this._status = PicturePageState.error;
      this._error = exception.message;
      log("Erro crítico ao atualizar a foto do usuário!", error: exception, stackTrace: stackTrace);
    }
  }
}