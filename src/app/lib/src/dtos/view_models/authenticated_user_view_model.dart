class AuthenticatedUserViewModel {
  final int userId;
  final String fullname;
  final String nickname;
  final String email;
  final String picture;

  const AuthenticatedUserViewModel({
    required this.userId,
    required this.fullname,
    required this.nickname,
    required this.email,
    required this.picture
  });

  factory AuthenticatedUserViewModel.fromMap(Map<String, dynamic> map) => AuthenticatedUserViewModel(
    userId: map["userId"] as int,
    fullname: map["fullname"] as String,
    nickname: map["nickname"] as String,
    email: map["email"] as String,
    picture: map["picture"] as String
  );
}