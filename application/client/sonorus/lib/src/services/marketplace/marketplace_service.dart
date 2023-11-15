
import "package:sonorus/src/models/product_model.dart";

abstract interface class MarketplaceService {
  Future<List<ProductModel>> getAllProducts();
  Future<List<ProductModel>> getAllProductsByName(String name);
  Future<void> deleteProductById(int productId);
}