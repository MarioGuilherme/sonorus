import "package:image_picker/image_picker.dart";

import "package:sonorus/src/core/extensions/trim_or_null_extension.dart";
import "package:sonorus/src/domain/enums/condition_type.dart";
import "package:sonorus/src/dtos/input_models/create_product_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_product_input_model.dart";
import "package:sonorus/src/dtos/view_models/product_view_model.dart";
import "package:sonorus/src/repositories/product/product_repository.dart";
import "package:sonorus/src/services/product/product_service.dart";

class ProductServiceImpl implements ProductService {
  final ProductRepository _repository;

  ProductServiceImpl(this._repository);

  @override
  Future<void> deleteByProductId(int productId) => this._repository.deleteByProductId(productId);

  @override
  Future<List<ProductViewModel>> getAllWithQuery(String? name) => this._repository.getAllWithQuery(name);

  @override
  Future<ProductViewModel> saveProduct(int? productId, String name, double price, String? description, ConditionType condition, List<XFile> newMedias, List<int>? mediasToRemove) async {
    if (productId == null) {
      final CreateProductInputModel inputModel = CreateProductInputModel(
        name: name,
        description: description.trimOrNull(),
        price: price,
        condition: condition,
        medias: newMedias
      );
      final ProductViewModel productViewModel = await this._repository.createProduct(inputModel);
      return productViewModel;
    }

    final UpdateProductInputModel inputModel = UpdateProductInputModel(
      name: name,
      description: description.trimOrNull(),
      price: price,
      condition: condition,
      newMedias: newMedias,
      mediasToRemove: mediasToRemove!
    );
    final ProductViewModel productViewModel = await this._repository.updateProduct(productId, inputModel);
    return productViewModel;
  }
}