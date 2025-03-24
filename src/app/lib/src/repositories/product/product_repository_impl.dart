import "package:dio/dio.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/domain/exceptions/authenticated_user_are_not_owner_of_product_exception.dart";
import "package:sonorus/src/domain/exceptions/invalid_form_exception.dart";
import "package:sonorus/src/domain/exceptions/product_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/dtos/input_models/create_product_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_product_input_model.dart";
import "package:sonorus/src/dtos/view_models/product_view_model.dart";
import "package:sonorus/src/repositories/product/product_repository.dart";

class ProductRepositoryImpl implements ProductRepository {
  final HttpClient _httpClient;

  ProductRepositoryImpl(this._httpClient);

  @override
  Future<ProductViewModel> createProduct(CreateProductInputModel inputModel) async {
    try {
      final Response result = await this._httpClient.auth().post("/products", data: inputModel.toFormData());
      return ProductViewModel.fromMap(result.data);
    } on Exception catch (exception) {
      if (exception is DioException)
        if (exception.response?.statusCode == 400) throw InvalidFormException.fromResponse(exception.response!);
      throw RepositoryException();
    }
  }

  @override
  Future<void> deleteByProductId(int productId) async {
    try {
      await this._httpClient.auth().delete("/products/$productId");
    } on Exception catch (exception) {
      if (exception is DioException) {
        if (exception.response?.statusCode == 403) throw AuthenticatedUserAreNotOwnerOfProductException();
        if (exception.response?.statusCode == 404) throw ProductNotFoundException();
      }
      throw RepositoryException();
    }
  }

  @override
  Future<List<ProductViewModel>> getAllWithQuery(String? name) async {
    try {
      final Response result = await this._httpClient.auth().get("/products${name == null ? "" : "?name=$name"}");
      return result.data.map<ProductViewModel>((product) => ProductViewModel.fromMap(product)).toList();
    } on Exception {
      throw RepositoryException();
    }
  }

  @override
  Future<ProductViewModel> updateProduct(int productId, UpdateProductInputModel inputModel) async {
    try {
      final Response result = await this._httpClient.auth().patch("/products/$productId", data: inputModel.toFormData());
      return ProductViewModel.fromMap(result.data);
    } on Exception catch (exception) {
      if (exception is DioException) {
        if (exception.response?.statusCode == 400) throw InvalidFormException.fromResponse(exception.response!);
        if (exception.response?.statusCode == 403) throw AuthenticatedUserAreNotOwnerOfProductException();
        if (exception.response?.statusCode == 404) throw ProductNotFoundException();
      }
      throw RepositoryException();
    }
  }
}