import "package:image_picker/image_picker.dart";

import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/opportunity_model.dart";
import "package:sonorus/src/models/opportunity_model_register.dart";
import "package:sonorus/src/models/post_register_model.dart";
import "package:sonorus/src/models/product_model.dart";
import "package:sonorus/src/models/product_register_model.dart";
import "package:sonorus/src/repositories/creation/creation_repository.dart";
import "package:sonorus/src/services/creation/creation_service.dart";

class CreationServiceImpl implements CreationService {
  final CreationRepository _creationRepository;

  CreationServiceImpl(this._creationRepository);

  @override
  Future<void> createPost(PostRegisterModel product) async => this._creationRepository.createPost(product);

  @override
  Future<ProductModel> createProduct(ProductRegisterModel product, List<XFile> medias) async => this._creationRepository.createProduct(product, medias);

  @override
  Future<void> updateProduct(ProductRegisterModel product, List<XFile> medias) async => this._creationRepository.updateProduct(product, medias);

  @override
  Future<void> updatePost(PostRegisterModel post, List<XFile> medias) async => this._creationRepository.updatePost(post, medias);

  @override
  Future<OpportunityModel> createOpportunity(OpportunityRegisterModel opportunity) async {
    return this._creationRepository.createOpportunity(OpportunityRegisterModel(
      name: opportunity.name.trim(),
      experienceRequired: opportunity.experienceRequired.trim(),
      isWork: opportunity.isWork,
      bandName: opportunity.bandName == null ? null : opportunity.bandName!.trim(),
      description: (opportunity.description == null || (opportunity.description?.isEmpty ?? true)) ? null : opportunity.description!.trim(),
      payment: opportunity.payment,
      workTimeUnit: opportunity.workTimeUnit
    ));
  }
  @override
  Future<void> updateOpportunity(OpportunityRegisterModel opportunity) async => this._creationRepository.updateOpportunity(OpportunityRegisterModel(
    opportunityId: opportunity.opportunityId,
    name: opportunity.name.trim(),
    experienceRequired: opportunity.experienceRequired.trim(),
    isWork: opportunity.isWork,
    bandName: opportunity.bandName == null ? null : opportunity.bandName!.trim(),
    description: (opportunity.description == null || (opportunity.description?.isEmpty ?? true)) ? null : opportunity.description!.trim(),
    payment: opportunity.payment,
    workTimeUnit: opportunity.workTimeUnit
  ));

  @override
  Future<List<InterestModel>> getInterests() async => this._creationRepository.getAllInterests();
}
