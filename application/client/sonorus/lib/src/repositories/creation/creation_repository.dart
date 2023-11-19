import "package:image_picker/image_picker.dart";

import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/opportunity_model.dart";
import "package:sonorus/src/models/opportunity_model_register.dart";
import "package:sonorus/src/models/post_register_model.dart";
import "package:sonorus/src/models/product_model.dart";
import "package:sonorus/src/models/product_register_model.dart";

abstract interface class CreationRepository {
  Future<void> createPost(PostRegisterModel newPost);
  Future<List<InterestModel>> getAllInterests();
  Future<ProductModel> createProduct(ProductRegisterModel product, List<XFile> medias);
  Future<void> updateProduct(ProductRegisterModel product, List<XFile> medias);
  Future<void> updatePost(PostRegisterModel post, List<XFile> medias);
  Future<OpportunityModel> createOpportunity(OpportunityRegisterModel opportunity);
  Future<void> updateOpportunity(OpportunityRegisterModel opportunity);
}