import "package:sonorus/src/domain/enums/work_time_unit.dart";
import "package:sonorus/src/dtos/view_models/user_view_model.dart";

class OpportunityViewModel {
  final int opportunityId;
  final String name;
  final String? bandName;
  final String? description;
  final String experienceRequired;
  final double payment;
  final bool isWork;
  final WorkTimeUnit? workTimeUnit;
  final DateTime announcedAt;
  final UserViewModel? recruiter;

  OpportunityViewModel({
    required this.opportunityId,
    required this.name,
    this.bandName,
    this.description,
    required this.experienceRequired,
    required this.payment,
    required this.isWork,
    this.workTimeUnit,
    required this.announcedAt,
    required this.recruiter
  });

  String get workTimeUnitString => switch (this.workTimeUnit) {
    null => "",
    WorkTimeUnit.perDays => "/dia",
    WorkTimeUnit.perHours => "/hora",
    WorkTimeUnit.perShow => "/show",
  };

  factory OpportunityViewModel.fromMap(Map<String, dynamic> map) => OpportunityViewModel(
    opportunityId: map["opportunityId"] as int,
    name: map["name"] as String,
    bandName: map["bandName"] != null ? map["bandName"] as String : null,
    description: map["description"] != null ? map["description"] as String : null,
    experienceRequired: map["experienceRequired"] as String,
    payment: map["payment"] as double,
    isWork: map["isWork"] as bool,
    workTimeUnit: map["workTimeUnit"] != null ? WorkTimeUnit.parse(map["workTimeUnit"] as int) : null,
    announcedAt: DateTime.parse(map["announcedAt"] as String),
    recruiter: UserViewModel.fromMap(map["recruiter"])
  );
}