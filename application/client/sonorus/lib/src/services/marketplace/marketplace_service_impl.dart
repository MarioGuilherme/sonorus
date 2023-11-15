import "package:sonorus/src/models/product_model.dart";
import "package:sonorus/src/repositories/marketplace/marketplace_repository.dart";
import "package:sonorus/src/services/marketplace/marketplace_service.dart";

class MarketplaceServiceImpl implements MarketplaceService {
  final MarketplaceRepository _productRepository;

  MarketplaceServiceImpl(this._productRepository);

  @override
  Future<List<ProductModel>> getAllProducts() async => this._productRepository.getAllProducts();

  @override
  Future<List<ProductModel>> getAllProductsByName(String name) async => this._productRepository.getAllProductsByName(name);
  
  @override
  Future<void> deleteProductById(int productId) async => this._productRepository.deleteProductById(productId);
}