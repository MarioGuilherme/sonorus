import "package:sonorus/src/domain/enums/work_time_unit.dart";
import "package:sonorus/src/dtos/view_models/opportunity_view_model.dart";

abstract interface class OpportunityService {
  Future<void> deleteByOpportunityId(int opportunityId);
  Future<List<OpportunityViewModel>> getAllWithQuery(String? name);
  Future<OpportunityViewModel> saveOpportunity(int? opportunityId, String name, String? bandName, String? description,  String experienceRequired, double payment, bool isWork, WorkTimeUnit? workTimeUnit);
}