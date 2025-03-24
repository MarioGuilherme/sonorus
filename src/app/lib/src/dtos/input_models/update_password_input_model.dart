import "dart:convert";

class UpdatePasswordInputModel {
  final String password;

  UpdatePasswordInputModel({ required this.password });

  String toJson() => json.encode({ "password": password });
}