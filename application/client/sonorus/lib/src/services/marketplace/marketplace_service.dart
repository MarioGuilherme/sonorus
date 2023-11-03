
import "package:sonorus/src/models/product_model.dart";

abstract interface class MarketplaceService {
  Future<List<ProductModel>> getAllProducts();
}