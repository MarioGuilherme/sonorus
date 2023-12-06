import "package:sonorus/src/models/opportunity_model.dart";

abstract interface class BusinessRepository {
  Future<List<OpportunityModel>> getAllOpportunities();
  Future<List<OpportunityModel>> getAllOpportunitiesByName(String name);
  Future<void> deleteOpportunityById(int opportunityId);
}