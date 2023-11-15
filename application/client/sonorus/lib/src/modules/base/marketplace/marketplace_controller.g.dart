// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MarketplaceController on _MarketplaceControllerBase, Store {
  late final _$_marketplaceStatusAtom = Atom(
      name: '_MarketplaceControllerBase._marketplaceStatus', context: context);

  MarketplaceStateStatus get marketplaceStatus {
    _$_marketplaceStatusAtom.reportRead();
    return super._marketplaceStatus;
  }

  @override
  MarketplaceStateStatus get _marketplaceStatus => marketplaceStatus;

  @override
  set _marketplaceStatus(MarketplaceStateStatus value) {
    _$_marketplaceStatusAtom.reportWrite(value, super._marketplaceStatus, () {
      super._marketplaceStatus = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: '_MarketplaceControllerBase._errorMessage', context: context);

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

  late final _$_productsAtom =
      Atom(name: '_MarketplaceControllerBase._products', context: context);

  List<ProductModel> get products {
    _$_productsAtom.reportRead();
    return super._products;
  }

  @override
  List<ProductModel> get _products => products;

  @override
  set _products(List<ProductModel> value) {
    _$_productsAtom.reportWrite(value, super._products, () {
      super._products = value;
    });
  }

  late final _$getAllProductsAsyncAction = AsyncAction(
      '_MarketplaceControllerBase.getAllProducts',
      context: context);

  @override
  Future<void> getAllProducts() {
    return _$getAllProductsAsyncAction.run(() => super.getAllProducts());
  }

  late final _$filterByNameAsyncAction =
      AsyncAction('_MarketplaceControllerBase.filterByName', context: context);

  @override
  Future<void> filterByName(String name) {
    return _$filterByNameAsyncAction.run(() => super.filterByName(name));
  }

  late final _$deleteProductByIdAsyncAction = AsyncAction(
      '_MarketplaceControllerBase.deleteProductById',
      context: context);

  @override
  Future<void> deleteProductById(int productId) {
    return _$deleteProductByIdAsyncAction
        .run(() => super.deleteProductById(productId));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
