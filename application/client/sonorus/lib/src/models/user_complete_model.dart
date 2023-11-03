// ignore_for_file: public_member_api_docs, sort_constructors_first

import "dart:convert";

import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/post_model.dart";
import "package:sonorus/src/models/user_model.dart";

class UserCompleteModel extends UserModel {
  List<InterestModel> interests;
  List<PostModel> posts;
  List<UserModel> friends;

  int get totalFriends => this.friends.length;

  UserCompleteModel({
    required super.userId,
    required super.nickname,
    required super.picture,
    required this.interests,
    required this.posts,
    required this.friends
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "userId": userId,
      "nickname": nickname,
      "picture": picture,
      "interests": interests.map((i) => i.toMap()).toList(),
      "posts": posts.map((p) => p.toMap()).toList(),
      "friends": friends.map((f) => f.toMap()).toList()
    };
  }

  factory UserCompleteModel.fromMap(Map<String, dynamic> map) {
    return UserCompleteModel(
      userId: map["userId"] as int,
      nickname: map["nickname"] as String,
      picture: map["picture"] as String,
      interests: List<InterestModel>.from((map["interests"] as List<int>).map<InterestModel>((x) => InterestModel.fromMap(x as Map<String,dynamic>),),),
      posts: List<PostModel>.from((map["posts"] as List<int>).map<PostModel>((x) => PostModel.fromMap(x as Map<String,dynamic>),),),
      friends: List<UserModel>.from((map["friends"] as List<int>).map<UserModel>((x) => UserModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  @override
  String toJson() => json.encode(this.toMap());

  factory UserCompleteModel.fromJson(String source) => UserCompleteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}