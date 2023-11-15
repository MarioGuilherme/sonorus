import "dart:convert";

import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/media_model.dart";
import "package:sonorus/src/models/post_base_model.dart";
import "package:sonorus/src/models/user_model.dart";

class PostWithAuthorModel extends PostBaseModel {
  final UserModel author;

  PostWithAuthorModel({
    required super.postId,
    required this.author,
    required super.content,
    required super.postedAt,
    required super.totalLikes,
    required super.totalComments,
    required super.isLikedByMe,
    required super.medias,
    required super.interests,
    super.tablature
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      "author": author.toMap()
    };
  }

  factory PostWithAuthorModel.fromMap(Map<String, dynamic> map) {
    return PostWithAuthorModel(
      postId: map["postId"] as int,
      author: UserModel.fromMap(map["author"]),
      content: map["content"] == null ? null : map["content"] as String,
      postedAt: DateTime.parse(map["postedAt"]),
      totalComments: map["totalComments"] as int,
      totalLikes: map["totalLikes"] as int,
      isLikedByMe: map["isLikedByMe"] as bool,
      medias: List<MediaModel>.from(map["medias"].map((media) => MediaModel.fromMap(media)).toList()),
      interests: List<InterestModel>.from(map["interests"].map((interest) => InterestModel.fromMap(interest)).toList()),
      tablature: map["tablature"]
    );
  }

  @override
  String toJson() => json.encode(this.toMap());

  factory PostWithAuthorModel.fromJson(String source) => PostWithAuthorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}