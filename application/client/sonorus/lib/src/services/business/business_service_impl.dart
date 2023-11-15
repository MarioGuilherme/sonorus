import "package:sonorus/src/models/opportunity_model.dart";
import "package:sonorus/src/repositories/business/business_repository.dart";
import "package:sonorus/src/services/business/business_service.dart";

class BusinessServiceImpl implements BusinessService {
  final BusinessRepository _businessRepository;

  BusinessServiceImpl(this._businessRepository);

  @override
  Future<List<OpportunityModel>> getAllOpportunities() async => this._businessRepository.getAllOpportunities();
  
  @override
  Future<void> deleteOpportunityById(int opportunityId) async => this._businessRepository.deleteOpportunityById(opportunityId);
}