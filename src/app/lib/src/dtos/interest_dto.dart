import "package:sonorus/src/domain/enums/interest_type.dart";

class InterestDto {
  final int interestId;
  final String? key;
  final String? value;
  final InterestType? type;

  InterestDto({
    this.interestId = 0,
    this.key,
    this.value,
    this.type
  });

  Map<String, dynamic> toMap() => {
    "interestId": interestId,
    "key": key,
    "value": value,
    "type": type?.id
  };

  factory InterestDto.fromMap(Map<String, dynamic> map) => InterestDto(
    interestId: map["interestId"] as int,
    key: map["key"] != null ? map["key"] as String : null,
    value: map["value"] != null ? map["value"] as String : null,
    type: map["type"] != null ? InterestType.parse(map["type"]) : null
  );
}