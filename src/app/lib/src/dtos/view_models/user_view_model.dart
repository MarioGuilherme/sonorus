class UserViewModel {
  final int userId;
  final String nickname;
  final String picture;

  const UserViewModel({
    required this.userId,
    required this.nickname,
    required this.picture
  });

  factory UserViewModel.fromMap(Map<String, dynamic> map) => UserViewModel(
    userId: map["userId"] as int,
    nickname: map["nickname"] as String,
    picture: map["picture"] as String
  );
}