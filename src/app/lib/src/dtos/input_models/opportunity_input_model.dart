import "dart:convert";

import "package:sonorus/src/domain/enums/work_time_unit.dart";

class OpportunityInputModel {
  final String name;
  final String? bandName;
  final String? description;
  final String experienceRequired;
  final double payment;
  final bool isWork;
  final WorkTimeUnit? workTimeUnit;

  OpportunityInputModel({
    required this.name,
    this.bandName,
    this.description,
    required this.experienceRequired,
    required this.payment,
    required this.isWork,
    this.workTimeUnit,
  });

  String toJson() => json.encode({
    "name": name,
    "bandName": bandName,
    "description": description,
    "experienceRequired": experienceRequired,
    "payment": payment,
    "isWork": isWork,
    "workTimeUnit": workTimeUnit?.id
  });
}