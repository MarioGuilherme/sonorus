import "package:image_picker/image_picker.dart";

import "package:sonorus/src/domain/enums/condition_type.dart";
import "package:sonorus/src/dtos/view_models/product_view_model.dart";

abstract interface class ProductService {
  Future<void> deleteByProductId(int productId);
  Future<List<ProductViewModel>> getAllWithQuery(String? name);
  Future<ProductViewModel> saveProduct(int? productId, String name, double price, String? description, ConditionType condition, List<XFile> newMedias, List<int>? mediasToRemove);
}