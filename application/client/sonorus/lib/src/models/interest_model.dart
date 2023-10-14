import "dart:convert";

class InterestModel {
  final int interestId;
  final String key;
  final String value;
  final InterestType type;

  InterestModel({
    required this.interestId,
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
      interestId: map["interestId"] as int,
      key: map["key"] as String,
      value: map["value"] as String,
      type: InterestType.parse(map["type"])
    );
  }

  String toJson() => json.encode(this.toMap());

  factory InterestModel.fromJson(String source) => InterestModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum InterestType {
  band(0),
  musicalGenre(1),
  skill(2);

  final int id;

  const InterestType(this.id);

  static InterestType parse(int id) => values.firstWhere((element) => element.id == id);
}