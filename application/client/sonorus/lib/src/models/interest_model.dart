import "dart:convert";

class InterestModel {
  int? idInterest;
  String? key;
  String? value;
  InterestType? type;

  InterestModel({
    this.idInterest,
    this.key,
    this.value,
    this.type
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "idInterest": idInterest,
      "key": key,
      "value": value,
      "type": type?.id,
    };
  }

  factory InterestModel.fromMap(Map<String, dynamic> map) {
    return InterestModel(
      idInterest: map["idInterest"] != null ? map["idInterest"] as int : null,
      key: map["key"] != null ? map["key"] as String : null,
      value: map["value"] != null ? map["value"] as String : null,
      type: InterestType.parse(map["type"])
    );
  }

  String toJson() => json.encode(toMap());

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