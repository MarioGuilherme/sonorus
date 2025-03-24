import "package:sonorus/src/dtos/input_models/opportunity_input_model.dart";
import "package:sonorus/src/dtos/view_models/opportunity_view_model.dart";

abstract interface class OpportunityRepository {
  Future<OpportunityViewModel> createOpportunity(OpportunityInputModel inputModel);
  Future<void> deleteByOpportunityId(int opportunityId);
  Future<List<OpportunityViewModel>> getAllWithQuery(String? name);
  Future<OpportunityViewModel> updateOpportunity(int opportunityId, OpportunityInputModel inputModel);
}