// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";

import "package:sonorus/src/models/form_error_model.dart";

class RestResponseModel {
  String? message;
  dynamic data;
  List<FormErrorModel>? errors;

  RestResponseModel({
    this.message,
    required this.data,
    this.errors,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "message": message,
      "data": data,
      "errors": errors?.map((x) => x.toMap()).toList(),
    };
  }

  factory RestResponseModel.fromMap(Map<String, dynamic> map) {
    return RestResponseModel(
      message: map["message"] != null ? map["message"] as String : null,
      data: map["data"] as dynamic,
      errors: map["errors"] != null ? List<FormErrorModel>.from((map["errors"]).map<FormErrorModel?>((x) => FormErrorModel.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(this.toMap());

  factory RestResponseModel.fromJson(String source) => RestResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}