// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";

import "package:sonorus/src/models/user_model.dart";

class CommentModel {
  final int commentId;
  UserModel? author;
  final String content;
  final DateTime commentedAt;
  int totalLikes;
  bool isLikedByMe;

  CommentModel({
    required this.commentId,
    this.author,
    required this.content,
    required this.commentedAt,
    required this.totalLikes,
    required this.isLikedByMe,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "commentId": commentId,
      "author": author?.toMap(),
      "content": content,
      "commentedAt": commentedAt.millisecondsSinceEpoch,
      "totalLikes": totalLikes,
      "isLikedByMe": isLikedByMe
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map["commentId"] as int,
      author: map["author"] != null ? UserModel.fromMap(map["author"] as Map<String,dynamic>) : null,
      content: map["content"] as String,
      commentedAt: DateTime.parse(map["commentedAt"]),
      totalLikes: map["totalLikes"] as int,
      isLikedByMe: map["isLikedByMe"] as bool
    );
  }

  String toJson() => json.encode(this.toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
