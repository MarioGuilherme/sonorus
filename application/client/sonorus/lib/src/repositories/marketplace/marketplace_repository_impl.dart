import "package:dio/dio.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/product_model.dart";
import "package:sonorus/src/models/rest_response_model.dart";
import "package:sonorus/src/repositories/marketplace/marketplace_repository.dart";

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  final HttpClient _httpClient;

  MarketplaceRepositoryImpl(this._httpClient);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final Response result = await this._httpClient.marketplaceMS().unauth().get("/products");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<ProductModel>((product) => ProductModel.fromMap(product)).toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getAllProductsByName(String name) async {
    try {
      final Response result = await this._httpClient.marketplaceMS().unauth().get("/products/$name");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<ProductModel>((product) => ProductModel.fromMap(product)).toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> deleteProductById(int productId) async {
    try {
      final Response result = await this._httpClient.marketplaceMS().auth().delete("/products/$productId");
      if (result.statusCode != 204)
        throw Exception("Falha ao excluir o anúncio");
    } on DioException {
      rethrow;
    }
  }
}