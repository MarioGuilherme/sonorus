// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PictureController on PictureControllerBase, Store {
  late final _$_statusAtom =
      Atom(name: 'PictureControllerBase._status', context: context);

  PicturePageState get status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  PicturePageState get _status => status;

  @override
  set _status(PicturePageState value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
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

  late final _$_errorAtom =
      Atom(name: 'PictureControllerBase._error', context: context);

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

  late final _$changePictureUserAsyncAction =
      AsyncAction('PictureControllerBase.changePictureUser', context: context);

  @override
  Future<void> changePictureUser(XFile picture) {
    return _$changePictureUserAsyncAction
        .run(() => super.changePictureUser(picture));
  }

  late final _$updatePictureAsyncAction =
      AsyncAction('PictureControllerBase.updatePicture', context: context);

  @override
  Future<void> updatePicture() {
    return _$updatePictureAsyncAction.run(() => super.updatePicture());
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
