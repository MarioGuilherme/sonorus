// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";
import "dart:convert";

import "package:intl/intl.dart";

import "package:sonorus/src/models/user_model.dart";
import "package:sonorus/src/models/work_time_unit.dart";

class OpportunityRegisterModel {
  final int? opportunityId;
  final String name;
  final String? description;
  final String? bandName;
  final String experienceRequired;
  final double? payment;
  final bool isWork;
  final WorkTimeUnit workTimeUnit;

  OpportunityRegisterModel({
    this.opportunityId,
    required this.name,
    this.description,
    this.bandName,
    required this.experienceRequired,
    this.payment,
    required this.isWork,
    required this.workTimeUnit
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "opportunityId": opportunityId,
      "name": name,
      "description": description,
      "bandName": bandName,
      "experienceRequired": experienceRequired,
      "payment": payment,
      "isWork": isWork,
      "workTimeUnit": workTimeUnit.id
    };
  }

  factory OpportunityRegisterModel.fromMap(Map<String, dynamic> map) {
    return OpportunityRegisterModel(
      opportunityId: map["opportunityId"] != null ? map["opportunityId"] as int : null,
      name: map["name"] as String,
      description: map["description"] != null ? map["description"] as String : null,
      bandName: map["bandName"] != null ? map["bandName"] as String : null,
      experienceRequired: map["experienceRequired"] as String,
      payment: map["payment"] != null ? map["payment"] as double : null,
      isWork: map["isWork"] as bool,
      workTimeUnit: WorkTimeUnit.parse(map["workTimeUnit"] as int)
    );
  }

  String toJson() => json.encode(toMap());

  factory OpportunityRegisterModel.fromJson(String source) => OpportunityRegisterModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
