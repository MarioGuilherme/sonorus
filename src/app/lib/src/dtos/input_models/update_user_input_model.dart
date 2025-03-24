import "dart:convert";

class UpdateUserInputModel {
  final String fullname;
  final String nickname;
  final String email;

  UpdateUserInputModel({
    required this.fullname,
    required this.nickname,
    required this.email
  });

  String toJson() => json.encode({
    "fullname": fullname,
    "nickname": nickname,
    "email": email
  });
}