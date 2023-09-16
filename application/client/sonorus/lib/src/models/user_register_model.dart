import "dart:convert";

class UserRegisterModel {
  final String fullName;
  final String nickname;
  final String email;
  final String password;

  UserRegisterModel({
    required this.fullName,
    required this.nickname,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "fullName": fullName,
      "nickname": nickname,
      "email": email,
      "password": password,
    };
  }

  factory UserRegisterModel.fromMap(Map<String, dynamic> map) {
    return UserRegisterModel(
      fullName: map["fullName"] as String,
      nickname: map["nickname"] as String,
      email: map["email"] as String,
      password: map["password"] as String,
    );
  }

  String toJson() => json.encode(this.toMap());

  factory UserRegisterModel.fromJson(String source) => UserRegisterModel.fromMap(json.decode(source) as Map<String, dynamic>);
}