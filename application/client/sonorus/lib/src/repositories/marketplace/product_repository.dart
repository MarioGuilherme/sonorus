
import "package:sonorus/src/models/product_model.dart";

abstract interface class MarketplaceRepository {
  Future<List<ProductModel>> getAllProducts();
}