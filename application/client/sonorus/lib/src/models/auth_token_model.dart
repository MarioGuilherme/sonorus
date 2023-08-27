import "dart:convert";

class AuthTokenModel {
  final String? accessToken;
  final String? refreshToken;

  AuthTokenModel(this.accessToken, this.refreshToken);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    };
  }

  factory AuthTokenModel.fromMap(Map<String, dynamic> map) {
    return AuthTokenModel(
      map["accessToken"] != null ? map["accessToken"] as String : null,
      map["refreshToken"] != null ? map["refreshToken"] as String : null,
    );
  }

  String toJson() => json.encode(this.toMap());

  factory AuthTokenModel.fromJson(String source) => AuthTokenModel.fromMap(json.decode(source) as Map<String, dynamic>);
}