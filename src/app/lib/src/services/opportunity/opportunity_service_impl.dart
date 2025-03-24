import "package:sonorus/src/core/extensions/trim_or_null_extension.dart";
import "package:sonorus/src/domain/enums/work_time_unit.dart";
import "package:sonorus/src/dtos/input_models/opportunity_input_model.dart";
import "package:sonorus/src/dtos/view_models/opportunity_view_model.dart";
import "package:sonorus/src/repositories/opportunity/opportunity_repository.dart";
import "package:sonorus/src/services/opportunity/opportunity_service.dart";

class OpportunityServiceImpl implements OpportunityService {
  final OpportunityRepository _repository;

  OpportunityServiceImpl(this._repository);

  @override
  Future<void> deleteByOpportunityId(int opportunityId) => this._repository.deleteByOpportunityId(opportunityId);

  @override
  Future<List<OpportunityViewModel>> getAllWithQuery(String? name) => this._repository.getAllWithQuery(name.trimOrNull());

  @override
  Future<OpportunityViewModel> saveOpportunity(int? opportunityId, String name, String? bandName, String? description,  String experienceRequired, double payment, bool isWork, WorkTimeUnit? workTimeUnit) async {
    final OpportunityInputModel inputModel = OpportunityInputModel(
      name: name.trim(),
      bandName: !isWork ? bandName.trimOrNull() : null,
      description: description.trimOrNull(),
      experienceRequired: experienceRequired.trim(),
      payment: payment,
      isWork: isWork,
      workTimeUnit: workTimeUnit
    );

    return opportunityId == null
      ? await this._repository.createOpportunity(inputModel)
      : await this._repository.updateOpportunity(opportunityId, inputModel);
  }
}