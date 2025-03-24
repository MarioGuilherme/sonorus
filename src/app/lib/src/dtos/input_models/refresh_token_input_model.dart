import "dart:convert";

class RefreshTokenInputModel {
  final String refreshToken;

  RefreshTokenInputModel({ required this.refreshToken });

  String toJson() => json.encode({ "refreshToken": refreshToken });
}