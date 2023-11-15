import "dart:convert";

import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/media_model.dart";

class PostBaseModel {
  final int postId;
  final String? content;
  final DateTime postedAt;
  final List<MediaModel> medias;
  final List<InterestModel> interests;
  final String? tablature;
  int totalComments;
  int totalLikes;
  bool isLikedByMe;

  PostBaseModel({
    required this.postId,
    this.content,
    required this.postedAt,
    required this.totalLikes,
    required this.totalComments,
    required this.isLikedByMe,
    required this.medias,
    required this.interests,
    this.tablature,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "postId": postId,
      "content": content,
      "postedAt": postedAt.millisecondsSinceEpoch,
      "totalComments": totalComments,
      "totalLikes": totalLikes,
      "isLikedByMe": isLikedByMe,
      "medias": medias.map((x) => x.toMap()).toList(),
      "interests": interests.map((x) => x.toMap()).toList(),
      "tablature": tablature
    };
  }

  factory PostBaseModel.fromMap(Map<String, dynamic> map) {
    return PostBaseModel(
      postId: map["postId"] as int,
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

  String toJson() => json.encode(this.toMap());

  factory PostBaseModel.fromJson(String source) => PostBaseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}