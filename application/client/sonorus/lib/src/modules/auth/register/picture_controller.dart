import "dart:developer";

import "package:image_picker/image_picker.dart";
import "package:mobx/mobx.dart";
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
  String? _errorMessage;
  
  PictureControllerBase(this._authRepository);

  @action
  Future<void> changePictureUser(XFile picture) async => this._picture = picture;

  @action
  Future<void> savePicture() async {
    try {
      this._pictureStatus = PictureStateStatus.loading;
      await this._authRepository.savePicture(this._picture!);
      this._pictureStatus = PictureStateStatus.success;
    } catch (e, s) {
      log("Erro ao salvar a foto do usuário", error: e, stackTrace: s);
      this._errorMessage = "Tente novamente mais tarde";
      this._pictureStatus = PictureStateStatus.error;
    }
  }
}