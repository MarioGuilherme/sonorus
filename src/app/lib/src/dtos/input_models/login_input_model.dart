import "dart:convert";

class LoginInputModel {
  final String login;
  final String password;

  LoginInputModel({ required this.login, required this.password });

  String toJson() => json.encode({ "login": login, "password": password });
}