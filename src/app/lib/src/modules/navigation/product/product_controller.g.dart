// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductController on _ProductControllerBase, Store {
  late final _$_statusAtom =
      Atom(name: '_ProductControllerBase._status', context: context);

  ProductPageStatus get status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  ProductPageStatus get _status => status;

  @override
  set _status(ProductPageStatus value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
    });
  }

  late final _$_showFormAtom =
      Atom(name: '_ProductControllerBase._showForm', context: context);

  bool get showForm {
    _$_showFormAtom.reportRead();
    return super._showForm;
  }

  @override
  bool get _showForm => showForm;

  @override
  set _showForm(bool value) {
    _$_showFormAtom.reportWrite(value, super._showForm, () {
      super._showForm = value;
    });
  }

  late final _$_productIdAtom =
      Atom(name: '_ProductControllerBase._productId', context: context);

  int? get productId {
    _$_productIdAtom.reportRead();
    return super._productId;
  }

  @override
  int? get _productId => productId;

  @override
  set _productId(int? value) {
    _$_productIdAtom.reportWrite(value, super._productId, () {
      super._productId = value;
    });
  }

  late final _$_conditionTypeAtom =
      Atom(name: '_ProductControllerBase._conditionType', context: context);

  ConditionType get conditionType {
    _$_conditionTypeAtom.reportRead();
    return super._conditionType;
  }

  @override
  ConditionType get _conditionType => conditionType;

  @override
  set _conditionType(ConditionType value) {
    _$_conditionTypeAtom.reportWrite(value, super._conditionType, () {
      super._conditionType = value;
    });
  }

  late final _$_productsAtom =
      Atom(name: '_ProductControllerBase._products', context: context);

  ObservableList<ProductViewModel> get products {
    _$_productsAtom.reportRead();
    return super._products;
  }

  @override
  ObservableList<ProductViewModel> get _products => products;

  @override
  set _products(ObservableList<ProductViewModel> value) {
    _$_productsAtom.reportWrite(value, super._products, () {
      super._products = value;
    });
  }

  late final _$_oldMediasToRemoveAtom =
      Atom(name: '_ProductControllerBase._oldMediasToRemove', context: context);

  ObservableList<int> get oldMediasToRemove {
    _$_oldMediasToRemoveAtom.reportRead();
    return super._oldMediasToRemove;
  }

  @override
  ObservableList<int> get _oldMediasToRemove => oldMediasToRemove;

  @override
  set _oldMediasToRemove(ObservableList<int> value) {
    _$_oldMediasToRemoveAtom.reportWrite(value, super._oldMediasToRemove, () {
      super._oldMediasToRemove = value;
    });
  }

  late final _$_newMediasAtom =
      Atom(name: '_ProductControllerBase._newMedias', context: context);

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

  late final _$_oldMediasAtom =
      Atom(name: '_ProductControllerBase._oldMedias', context: context);

  ObservableList<MediaViewModel> get oldMedias {
    _$_oldMediasAtom.reportRead();
    return super._oldMedias;
  }

  @override
  ObservableList<MediaViewModel> get _oldMedias => oldMedias;

  @override
  set _oldMedias(ObservableList<MediaViewModel> value) {
    _$_oldMediasAtom.reportWrite(value, super._oldMedias, () {
      super._oldMedias = value;
    });
  }

  late final _$_savedProductAtom =
      Atom(name: '_ProductControllerBase._savedProduct', context: context);

  ProductViewModel? get savedProduct {
    _$_savedProductAtom.reportRead();
    return super._savedProduct;
  }

  @override
  ProductViewModel? get _savedProduct => savedProduct;

  @override
  set _savedProduct(ProductViewModel? value) {
    _$_savedProductAtom.reportWrite(value, super._savedProduct, () {
      super._savedProduct = value;
    });
  }

  late final _$_errorAtom =
      Atom(name: '_ProductControllerBase._error', context: context);

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

  late final _$getAllWithQueryAsyncAction =
      AsyncAction('_ProductControllerBase.getAllWithQuery', context: context);

  @override
  Future<void> getAllWithQuery({String? name}) {
    return _$getAllWithQueryAsyncAction
        .run(() => super.getAllWithQuery(name: name));
  }

  late final _$saveProductAsyncAction =
      AsyncAction('_ProductControllerBase.saveProduct', context: context);

  @override
  Future<void> saveProduct(String name, String? description, double price) {
    return _$saveProductAsyncAction
        .run(() => super.saveProduct(name, description, price));
  }

  late final _$_ProductControllerBaseActionController =
      ActionController(name: '_ProductControllerBase', context: context);

  @override
  void toggleShowForm(bool? showForm) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.toggleShowForm');
    try {
      return super.toggleShowForm(showForm);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProductId(int? productId) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setProductId');
    try {
      return super.setProductId(productId);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConditionType(ConditionType conditionType) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setConditionType');
    try {
      return super.setConditionType(conditionType);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addNewMedias(List<XFile> newMedias) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.addNewMedias');
    try {
      return super.addNewMedias(newMedias);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addOldMedias(List<MediaViewModel> oldMedias) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.addOldMedias');
    try {
      return super.addOldMedias(oldMedias);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeNewMedia(XFile newMedia) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.removeNewMedia');
    try {
      return super.removeNewMedia(newMedia);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeOldMedia(MediaViewModel oldMedia) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.removeOldMedia');
    try {
      return super.removeOldMedia(oldMedia);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeSavedOpportunity() {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.removeSavedOpportunity');
    try {
      return super.removeSavedOpportunity();
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
