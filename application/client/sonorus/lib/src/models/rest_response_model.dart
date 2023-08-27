import "dart:convert";

class RestResponseModel {
  String? message;
  dynamic data;

  RestResponseModel({
    this.message,
    this.data
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "message": message,
      "data": data,
    };
  }

  factory RestResponseModel.fromMap(Map<String, dynamic> map) {
    return RestResponseModel(
      message: map["message"] != null ? map["message"] as String : null,
      data: map["data"] as dynamic,
    );
  }

  String toJson() => json.encode(this.toMap());

  factory RestResponseModel.fromJson(String source) => RestResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}