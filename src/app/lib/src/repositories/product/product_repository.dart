import "package:sonorus/src/dtos/input_models/create_product_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_product_input_model.dart";
import "package:sonorus/src/dtos/view_models/product_view_model.dart";

abstract interface class ProductRepository {
  Future<ProductViewModel> createProduct(CreateProductInputModel inputModel);
  Future<void> deleteByProductId(int productId);
  Future<List<ProductViewModel>> getAllWithQuery(String? name);
  Future<ProductViewModel> updateProduct(int productId, UpdateProductInputModel inputModel);
}