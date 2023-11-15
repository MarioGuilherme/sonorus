import "dart:convert";

class AuthTokenModel {
  final String accessToken;
  final String refreshToken;

  AuthTokenModel(
    this.accessToken,
    this.refreshToken
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "accessToken": accessToken,
      "refreshToken": refreshToken
    };
  }

  factory AuthTokenModel.fromMap(Map<String, dynamic> map) {
    return AuthTokenModel(
      map["accessToken"] as String,
      map["refreshToken"] as String
    );
  }

  String toJson() => json.encode(this.toMap());

  factory AuthTokenModel.fromJson(String source) => AuthTokenModel.fromMap(json.decode(source) as Map<String, dynamic>);
}