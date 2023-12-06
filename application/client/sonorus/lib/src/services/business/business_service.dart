import "package:sonorus/src/models/opportunity_model.dart";

abstract interface class BusinessService {
  Future<List<OpportunityModel>> getAllOpportunities();
  Future<void> deleteOpportunityById(int opportunityId);
  Future<List<OpportunityModel>> getAllOpportunitiesByName(String name);
}