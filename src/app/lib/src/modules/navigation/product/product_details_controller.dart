// ignore_for_file: library_private_types_in_public_api
import "dart:developer";

import "package:flutter_modular/flutter_modular.dart";
import "package:mobx/mobx.dart";

import "package:sonorus/src/domain/exceptions/authenticated_user_are_not_owner_of_product_exception.dart";
import "package:sonorus/src/domain/exceptions/product_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/services/product/product_service.dart";

part "product_details_controller.g.dart";

class ProductDetailsController = _ProductDetailsControllerBase with _$ProductDetailsController;

enum ProductDetailsPageStatus {
  initial,
  deletingProduct,
  deletedProduct,
  error
}

abstract class _ProductDetailsControllerBase with Store {
  final ProductService _service;

  @readonly
  ProductDetailsPageStatus _status = ProductDetailsPageStatus.initial;

  @readonly
  String? _error;

  _ProductDetailsControllerBase(this._service);

  @action
  Future<void> deleteProductById(int productId) async {
    try {
      this._status = ProductDetailsPageStatus.deletingProduct;

      await this._service.deleteByProductId(productId);

      this._status = ProductDetailsPageStatus.deletedProduct;
    } on AuthenticatedUserAreNotOwnerOfProductException catch (exception) {
      this._status = ProductDetailsPageStatus.error;
      this._error = exception.message;
      Modular.to.pop();
    } on ProductNotFoundException catch (exception) {
      this._status = ProductDetailsPageStatus.error;
      this._error = exception.message;
      Modular.to.pop();
    } on RepositoryException catch (exception, stackTrace) {
      this._status = ProductDetailsPageStatus.error;
      this._error = exception.message;
      log("Erro crítico ao excluir o anúncio $productId!", error: exception, stackTrace: stackTrace);
    }
  }
}