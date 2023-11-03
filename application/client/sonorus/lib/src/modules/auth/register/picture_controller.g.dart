// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PictureController on PictureControllerBase, Store {
  late final _$_pictureStatusAtom =
      Atom(name: 'PictureControllerBase._pictureStatus', context: context);

  PictureStateStatus get pictureStatus {
    _$_pictureStatusAtom.reportRead();
    return super._pictureStatus;
  }

  @override
  PictureStateStatus get _pictureStatus => pictureStatus;

  @override
  set _pictureStatus(PictureStateStatus value) {
    _$_pictureStatusAtom.reportWrite(value, super._pictureStatus, () {
      super._pictureStatus = value;
    });
  }

  late final _$_pictureAtom =
      Atom(name: 'PictureControllerBase._picture', context: context);

  XFile? get picture {
    _$_pictureAtom.reportRead();
    return super._picture;
  }

  @override
  XFile? get _picture => picture;

  @override
  set _picture(XFile? value) {
    _$_pictureAtom.reportWrite(value, super._picture, () {
      super._picture = value;
    });
  }

  late final _$_pictureBytesAtom =
      Atom(name: 'PictureControllerBase._pictureBytes', context: context);

  Uint8List? get pictureBytes {
    _$_pictureBytesAtom.reportRead();
    return super._pictureBytes;
  }

  @override
  Uint8List? get _pictureBytes => pictureBytes;

  @override
  set _pictureBytes(Uint8List? value) {
    _$_pictureBytesAtom.reportWrite(value, super._pictureBytes, () {
      super._pictureBytes = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: 'PictureControllerBase._errorMessage', context: context);

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

  late final _$changePictureUserAsyncAction =
      AsyncAction('PictureControllerBase.changePictureUser', context: context);

  @override
  Future<void> changePictureUser(XFile picture) {
    return _$changePictureUserAsyncAction
        .run(() => super.changePictureUser(picture));
  }

  late final _$savePictureAsyncAction =
      AsyncAction('PictureControllerBase.savePicture', context: context);

  @override
  Future<void> savePicture() {
    return _$savePictureAsyncAction.run(() => super.savePicture());
  }

  late final _$PictureControllerBaseActionController =
      ActionController(name: 'PictureControllerBase', context: context);

  @override
  void removePicture() {
    final _$actionInfo = _$PictureControllerBaseActionController.startAction(
        name: 'PictureControllerBase.removePicture');
    try {
      return super.removePicture();
    } finally {
      _$PictureControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
