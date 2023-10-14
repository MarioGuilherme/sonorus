import "dart:convert";

class UserModel {
  final int userId;
  final String nickname;
  final String picture;

  UserModel({
    required this.userId,
    required this.nickname,
    required this.picture
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "userId": userId,
      "nickname": nickname,
      "picture": picture
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map["userId"] as int,
      nickname: map["nickname"] as String,
      picture: map["picture"] as String
    );
  }

  String toJson() => json.encode(this.toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}