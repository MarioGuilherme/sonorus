import "dart:convert";

class CreateUserInputModel {
  final String fullname;
  final String nickname;
  final String email;
  final String password;

  CreateUserInputModel({
    required this.fullname,
    required this.nickname,
    required this.email,
    required this.password
  });

  String toJson() => json.encode({
    "fullName": fullname,
    "nickname": nickname,
    "email": email,
    "password": password
  });
}