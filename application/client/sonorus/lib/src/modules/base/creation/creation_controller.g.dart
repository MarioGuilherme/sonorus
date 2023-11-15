// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creation_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreationController on _CreationControllerBase, Store {
  late final _$_creationStatusAtom =
      Atom(name: '_CreationControllerBase._creationStatus', context: context);

  CreationStateStatus get creationStatus {
    _$_creationStatusAtom.reportRead();
    return super._creationStatus;
  }

  @override
  CreationStateStatus get _creationStatus => creationStatus;

  @override
  set _creationStatus(CreationStateStatus value) {
    _$_creationStatusAtom.reportWrite(value, super._creationStatus, () {
      super._creationStatus = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: '_CreationControllerBase._errorMessage', context: context);

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

  late final _$_creationTypeAtom =
      Atom(name: '_CreationControllerBase._creationType', context: context);

  CreationType? get creationType {
    _$_creationTypeAtom.reportRead();
    return super._creationType;
  }

  @override
  CreationType? get _creationType => creationType;

  @override
  set _creationType(CreationType? value) {
    _$_creationTypeAtom.reportWrite(value, super._creationType, () {
      super._creationType = value;
    });
  }

  late final _$_conditionTypeAtom =
      Atom(name: '_CreationControllerBase._conditionType', context: context);

  ConditionType? get conditionType {
    _$_conditionTypeAtom.reportRead();
    return super._conditionType;
  }

  @override
  ConditionType? get _conditionType => conditionType;

  @override
  set _conditionType(ConditionType? value) {
    _$_conditionTypeAtom.reportWrite(value, super._conditionType, () {
      super._conditionType = value;
    });
  }

  late final _$_workTimeUnitAtom =
      Atom(name: '_CreationControllerBase._workTimeUnit', context: context);

  WorkTimeUnit get workTimeUnit {
    _$_workTimeUnitAtom.reportRead();
    return super._workTimeUnit;
  }

  @override
  WorkTimeUnit get _workTimeUnit => workTimeUnit;

  @override
  set _workTimeUnit(WorkTimeUnit value) {
    _$_workTimeUnitAtom.reportWrite(value, super._workTimeUnit, () {
      super._workTimeUnit = value;
    });
  }

  late final _$_lastProductCreatedAtom = Atom(
      name: '_CreationControllerBase._lastProductCreated', context: context);

  ProductModel? get lastProductCreated {
    _$_lastProductCreatedAtom.reportRead();
    return super._lastProductCreated;
  }

  @override
  ProductModel? get _lastProductCreated => lastProductCreated;

  @override
  set _lastProductCreated(ProductModel? value) {
    _$_lastProductCreatedAtom.reportWrite(value, super._lastProductCreated, () {
      super._lastProductCreated = value;
    });
  }

  late final _$_lastOpportunityCreatedAtom = Atom(
      name: '_CreationControllerBase._lastOpportunityCreated',
      context: context);

  OpportunityModel? get lastOpportunityCreated {
    _$_lastOpportunityCreatedAtom.reportRead();
    return super._lastOpportunityCreated;
  }

  @override
  OpportunityModel? get _lastOpportunityCreated => lastOpportunityCreated;

  @override
  set _lastOpportunityCreated(OpportunityModel? value) {
    _$_lastOpportunityCreatedAtom
        .reportWrite(value, super._lastOpportunityCreated, () {
      super._lastOpportunityCreated = value;
    });
  }

  late final _$_productMediaAtom =
      Atom(name: '_CreationControllerBase._productMedia', context: context);

  ObservableList<XFile> get productMedia {
    _$_productMediaAtom.reportRead();
    return super._productMedia;
  }

  @override
  ObservableList<XFile> get _productMedia => productMedia;

  @override
  set _productMedia(ObservableList<XFile> value) {
    _$_productMediaAtom.reportWrite(value, super._productMedia, () {
      super._productMedia = value;
    });
  }

  late final _$_postMediaAtom =
      Atom(name: '_CreationControllerBase._postMedia', context: context);

  ObservableList<XFile> get postMedia {
    _$_postMediaAtom.reportRead();
    return super._postMedia;
  }

  @override
  ObservableList<XFile> get _postMedia => postMedia;

  @override
  set _postMedia(ObservableList<XFile> value) {
    _$_postMediaAtom.reportWrite(value, super._postMedia, () {
      super._postMedia = value;
    });
  }

  late final _$_oldmediasAtom =
      Atom(name: '_CreationControllerBase._oldmedias', context: context);

  ObservableList<XFile> get oldmedias {
    _$_oldmediasAtom.reportRead();
    return super._oldmedias;
  }

  @override
  ObservableList<XFile> get _oldmedias => oldmedias;

  @override
  set _oldmedias(ObservableList<XFile> value) {
    _$_oldmediasAtom.reportWrite(value, super._oldmedias, () {
      super._oldmedias = value;
    });
  }

  late final _$_postOldmediasAtom =
      Atom(name: '_CreationControllerBase._postOldmedias', context: context);

  ObservableList<XFile> get postOldmedias {
    _$_postOldmediasAtom.reportRead();
    return super._postOldmedias;
  }

  @override
  ObservableList<XFile> get _postOldmedias => postOldmedias;

  @override
  set _postOldmedias(ObservableList<XFile> value) {
    _$_postOldmediasAtom.reportWrite(value, super._postOldmedias, () {
      super._postOldmedias = value;
    });
  }

  late final _$_newMediasAtom =
      Atom(name: '_CreationControllerBase._newMedias', context: context);

  ObservableList<XFile> get newMedias {
    _$_newMediasAtom.reportRead();
    return super._newMedias;
  }

  @override
  ObservableList<XFile> get _newMedias => newMedias;

  @override
  set _newMedias(ObservableList<XFile> value) {
    _$_newMediasAtom.reportWrite(value, super._newMedias, () {
      super._newMedias = value;
    });
  }

  late final _$_postnewmediasAtom =
      Atom(name: '_CreationControllerBase._postnewmedias', context: context);

  ObservableList<XFile> get postnewmedias {
    _$_postnewmediasAtom.reportRead();
    return super._postnewmedias;
  }

  @override
  ObservableList<XFile> get _postnewmedias => postnewmedias;

  @override
  set _postnewmedias(ObservableList<XFile> value) {
    _$_postnewmediasAtom.reportWrite(value, super._postnewmedias, () {
      super._postnewmedias = value;
    });
  }

  late final _$_allTagsAtom =
      Atom(name: '_CreationControllerBase._allTags', context: context);

  ObservableList<InterestModel> get allTags {
    _$_allTagsAtom.reportRead();
    return super._allTags;
  }

  @override
  ObservableList<InterestModel> get _allTags => allTags;

  @override
  set _allTags(ObservableList<InterestModel> value) {
    _$_allTagsAtom.reportWrite(value, super._allTags, () {
      super._allTags = value;
    });
  }

  late final _$_tagsSelectedToPostAtom = Atom(
      name: '_CreationControllerBase._tagsSelectedToPost', context: context);

  ObservableList<InterestModel> get tagsSelectedToPost {
    _$_tagsSelectedToPostAtom.reportRead();
    return super._tagsSelectedToPost;
  }

  @override
  ObservableList<InterestModel> get _tagsSelectedToPost => tagsSelectedToPost;

  @override
  set _tagsSelectedToPost(ObservableList<InterestModel> value) {
    _$_tagsSelectedToPostAtom.reportWrite(value, super._tagsSelectedToPost, () {
      super._tagsSelectedToPost = value;
    });
  }

  late final _$getAllInterestsAsyncAction =
      AsyncAction('_CreationControllerBase.getAllInterests', context: context);

  @override
  Future<void> getAllInterests() {
    return _$getAllInterestsAsyncAction.run(() => super.getAllInterests());
  }

  late final _$setOldTagsAsyncAction =
      AsyncAction('_CreationControllerBase.setOldTags', context: context);

  @override
  Future<void> setOldTags(List<InterestModel> interests) {
    return _$setOldTagsAsyncAction.run(() => super.setOldTags(interests));
  }

  late final _$createPostAsyncAction =
      AsyncAction('_CreationControllerBase.createPost', context: context);

  @override
  Future<void> createPost(String? content, String? tablature,
      List<int> interestsIds, List<XFile> medias) {
    return _$createPostAsyncAction
        .run(() => super.createPost(content, tablature, interestsIds, medias));
  }

  late final _$createProductAsyncAction =
      AsyncAction('_CreationControllerBase.createProduct', context: context);

  @override
  Future<void> createProduct(String name, String description, double price) {
    return _$createProductAsyncAction
        .run(() => super.createProduct(name, description, price));
  }

  late final _$updateProductAsyncAction =
      AsyncAction('_CreationControllerBase.updateProduct', context: context);

  @override
  Future<void> updateProduct(
      int productId,
      String name,
      ConditionType condition,
      String description,
      double price,
      List<XFile> medias) {
    return _$updateProductAsyncAction.run(() => super
        .updateProduct(productId, name, condition, description, price, medias));
  }

  late final _$updatePostAsyncAction =
      AsyncAction('_CreationControllerBase.updatePost', context: context);

  @override
  Future<void> updatePost(int postId, String? content, String? tablature,
      List<int> interestsIds, List<XFile> medias) {
    return _$updatePostAsyncAction.run(() =>
        super.updatePost(postId, content, tablature, interestsIds, medias));
  }

  late final _$createOpportunityAsyncAction = AsyncAction(
      '_CreationControllerBase.createOpportunity',
      context: context);

  @override
  Future<void> createOpportunity(String name, String description,
      String? bandName, String experience, double? payment, bool isToBand) {
    return _$createOpportunityAsyncAction.run(() => super.createOpportunity(
        name, description, bandName, experience, payment, isToBand));
  }

  late final _$_CreationControllerBaseActionController =
      ActionController(name: '_CreationControllerBase', context: context);

  @override
  void toggleTagToPost(InterestModel interestPressed) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.toggleTagToPost');
    try {
      return super.toggleTagToPost(interestPressed);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTagSelected(InterestModel interest) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.removeTagSelected');
    try {
      return super.removeTagSelected(interest);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addTagSelected(InterestModel interest) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.addTagSelected');
    try {
      return super.addTagSelected(interest);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool tagIsSelected(int interestId) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.tagIsSelected');
    try {
      return super.tagIsSelected(interestId);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleTypeCreation(CreationType? creationType) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.toggleTypeCreation');
    try {
      return super.toggleTypeCreation(creationType);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearLastProductRegistered() {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.clearLastProductRegistered');
    try {
      return super.clearLastProductRegistered();
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearLastOpportunityRegistered() {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.clearLastOpportunityRegistered');
    try {
      return super.clearLastOpportunityRegistered();
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleWorkTimeUnit(WorkTimeUnit workTimeUnit) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.toggleWorkTimeUnit');
    try {
      return super.toggleWorkTimeUnit(workTimeUnit);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleConditionProduct(ConditionType conditionType) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.toggleConditionProduct');
    try {
      return super.toggleConditionProduct(conditionType);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearProductMedias() {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.clearProductMedias');
    try {
      return super.clearProductMedias();
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearPostMedias() {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.clearPostMedias');
    try {
      return super.clearPostMedias();
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearOldMedias() {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.clearOldMedias');
    try {
      return super.clearOldMedias();
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearPostOldMedias() {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.clearPostOldMedias');
    try {
      return super.clearPostOldMedias();
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearnewMedias() {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.clearnewMedias');
    try {
      return super.clearnewMedias();
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearPostnewMedias() {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.clearPostnewMedias');
    try {
      return super.clearPostnewMedias();
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSelectedTags() {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.clearSelectedTags');
    try {
      return super.clearSelectedTags();
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMedias(List<XFile> medias) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.setMedias');
    try {
      return super.setMedias(medias);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMediasPost(List<XFile> medias) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.setMediasPost');
    try {
      return super.setMediasPost(medias);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setoldMMedias(List<XFile> medias) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.setoldMMedias');
    try {
      return super.setoldMMedias(medias);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPostldMMedias(List<XFile> medias) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.setPostldMMedias');
    try {
      return super.setPostldMMedias(medias);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeMedia(XFile mediaToRemove) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.removeMedia');
    try {
      return super.removeMedia(mediaToRemove);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeMediaPost(XFile mediaToRemove) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.removeMediaPost');
    try {
      return super.removeMediaPost(mediaToRemove);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFrom2list(XFile mediaToRemove) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.removeFrom2list');
    try {
      return super.removeFrom2list(mediaToRemove);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addNewMedias(List<XFile> mediasToAdd) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.addNewMedias');
    try {
      return super.addNewMedias(mediasToAdd);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addNewPostMedias(List<XFile> mediasToAdd) {
    final _$actionInfo = _$_CreationControllerBaseActionController.startAction(
        name: '_CreationControllerBase.addNewPostMedias');
    try {
      return super.addNewPostMedias(mediasToAdd);
    } finally {
      _$_CreationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
