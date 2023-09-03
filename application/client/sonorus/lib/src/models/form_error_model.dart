import "dart:convert";

class FormErrorModel {
  final String field;
  final String error;

  FormErrorModel({
    required this.field,
    required this.error
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "field": field,
      "error": error
    };
  }

  factory FormErrorModel.fromMap(Map<String, dynamic> map) {
    return FormErrorModel(
      field: map["field"] as String,
      error: map["error"] as String
    );
  }

  String toJson() => json.encode(this.toMap());

  factory FormErrorModel.fromJson(String source) => FormErrorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}