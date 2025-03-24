import "package:sonorus/src/dtos/view_models/authenticated_user_view_model.dart";

class AuthenticatedUser {
  int? userId;
  String? fullname;
  String? nickname;
  String? email;
  String? picture;

  AuthenticatedUser({
    this.userId,
    this.fullname,
    this.nickname,
    this.email,
    this.picture
  });

  void updateAfterLogin(AuthenticatedUserViewModel authenticatedUserViewModel) {
    this.userId = authenticatedUserViewModel.userId;
    this.fullname = authenticatedUserViewModel.fullname;
    this.nickname = authenticatedUserViewModel.nickname;
    this.email = authenticatedUserViewModel.email;
    this.picture = authenticatedUserViewModel.picture;
  }

  void clearSession() {
    this.userId = null;
    this.fullname = null;
    this.nickname = null;
    this.email = null;
    this.picture = null;
  }

  factory AuthenticatedUser.fromMap(Map<String, dynamic> map) => AuthenticatedUser(
    userId: map["userId"] as int,
    fullname: map["fullname"] as String,
    nickname: map["nickname"] as String,
    email: map["email"] as String,
    picture: map["picture"] as String,
  );
}