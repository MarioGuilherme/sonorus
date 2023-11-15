import "dart:convert";

import "package:sonorus/src/models/interest_type.dart";

class InterestModel {
  final int? interestId;
  final String key;
  final String value;
  final InterestType type;

  InterestModel({
    this.interestId,
    required this.key,
    required this.value,
    required this.type
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "interestId": interestId,
      "key": key,
      "value": value,
      "type": type.id
    };
  }

  factory InterestModel.fromMap(Map<String, dynamic> map) {
    return InterestModel(
      interestId: map["interestId"] == null ? null : map["interestId"] as int,
      key: map["key"] as String,
      value: map["value"] as String,
      type: InterestType.parse(map["type"])
    );
  }

  String toJson() => json.encode(this.toMap());

  factory InterestModel.fromJson(String source) => InterestModel.fromMap(json.decode(source) as Map<String, dynamic>);
}