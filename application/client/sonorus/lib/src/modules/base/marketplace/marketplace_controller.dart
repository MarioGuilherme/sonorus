// ignore_for_file: library_private_types_in_public_api

import "dart:developer";

import "package:mobx/mobx.dart";
import "package:sonorus/src/models/product_model.dart";
import "package:sonorus/src/services/marketplace/marketplace_service.dart";

part "marketplace_controller.g.dart";

class MarketplaceController = _MarketplaceControllerBase with _$MarketplaceController;

enum MarketplaceStateStatus {
  initial,
  loadingProducts,
  loadedProducts,
  error
}

abstract class _MarketplaceControllerBase with Store {
  final MarketplaceService _marketplaceService;

  @readonly
  MarketplaceStateStatus _marketplaceStatus = MarketplaceStateStatus.initial;

  @readonly
  String? _errorMessage;

  @readonly
  List<ProductModel> _products = <ProductModel>[];

  _MarketplaceControllerBase(this._marketplaceService);
  
  @action
  Future<void> getAllProducts() async {
    try {
      this._marketplaceStatus = MarketplaceStateStatus.loadingProducts;
      this._products = await this._marketplaceService.getAllProducts();
      this._marketplaceStatus = MarketplaceStateStatus.loadedProducts;
    }  on Exception catch (exception, stackTrace) {
      this._marketplaceStatus = MarketplaceStateStatus.error;
      log("Erro ao buscar os produtos", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> filterByName(String name) async {
    try {
      this._marketplaceStatus = MarketplaceStateStatus.loadingProducts;
      this._products = await this._marketplaceService.getAllProductsByName(name);
      this._marketplaceStatus = MarketplaceStateStatus.loadedProducts;
    }  on Exception catch (exception, stackTrace) {
      this._marketplaceStatus = MarketplaceStateStatus.error;
      log("Erro ao buscar os produtos", error: exception, stackTrace: stackTrace);
    }
  }

  @action
  Future<void> deleteProductById(int productId) async {
    try {
       await this._marketplaceService.deleteProductById(productId);
      this._products = this._products.where((product) => product.productId != productId).toList();
    }  on Exception catch (exception, stackTrace) {
      this._marketplaceStatus = MarketplaceStateStatus.error;
      log("Erro ao buscar os produtos", error: exception, stackTrace: stackTrace);
    }
  }
}