// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";

import "package:intl/intl.dart";

import "package:sonorus/src/models/user_model.dart";
import "package:sonorus/src/models/work_time_unit.dart";

class OpportunityModel {
  final int opportunityId;
  final UserModel recruiter;
  final String name;
  final String? bandName;
  final String? description;
  final String experienceRequired;
  final double payment;
  final bool isWork;
  final WorkTimeUnit? workTimeUnit;
  final DateTime announcedAt;

  OpportunityModel({
    required this.opportunityId,
    required this.recruiter,
    required this.name,
    this.bandName,
    this.description,
    required this.experienceRequired,
    required this.payment,
    required this.isWork,
    this.workTimeUnit,
    required this.announcedAt,
  });

  String get workTimeUnitString {
    if (this.workTimeUnit == null)
      return "";

    if (this.workTimeUnit == WorkTimeUnit.perHours)
      return "/hora";

    if (this.workTimeUnit == WorkTimeUnit.perDays)
      return "/hora";

    return "/show";
  }

  String get formatedCurrency {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: "pt_BR",
      symbol: r"R$"
    );
    return currencyFormat.format(this.payment);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "opportunityId": opportunityId,
      "recruiter": recruiter.toMap(),
      "name": name,
      "bandName": bandName,
      "description": description,
      "experienceRequired": experienceRequired,
      "payment": payment,
      "isWork": isWork,
      "workTimeUnit": workTimeUnit?.id,
      "announcedAt": announcedAt.millisecondsSinceEpoch,
    };
  }

  factory OpportunityModel.fromMap(Map<String, dynamic> map) {
    return OpportunityModel(
      opportunityId: map["opportunityId"] as int,
      recruiter: UserModel.fromMap(map["recruiter"] as Map<String,dynamic>),
      name: map["name"] as String,
      bandName: map["bandName"] != null ? map["bandName"] as String : null,
      description: map["description"] != null ? map["description"] as String : null,
      experienceRequired: map["experienceRequired"] as String,
      payment: map["payment"] as double,
      isWork: map["isWork"] as bool,
      workTimeUnit: map["workTimeUnit"] != null ? WorkTimeUnit.parse(map["workTimeUnit"] as int) : null,
      announcedAt: DateTime.parse(map["announcedAt"] as String),
    );
  }

  String toJson() => json.encode(this.toMap());

  factory OpportunityModel.fromJson(String source) => OpportunityModel.fromMap(json.decode(source) as Map<String, dynamic>);
}