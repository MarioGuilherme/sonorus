// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";

import "package:sonorus/src/models/user_model.dart";

class CommentModel {
  final int commentId;
  final UserModel user;
  final String content;
  final DateTime commentedAt;
  int totalLikes;
  bool isLikedByMe;

  CommentModel({
    required this.commentId,
    required this.user,
    required this.content,
    required this.commentedAt,
    required this.totalLikes,
    required this.isLikedByMe,
  });
  
  String get timeAgo {
    final DateTime now = DateTime.now();

    final int differenceSeconds = now.difference(this.commentedAt).inSeconds;
    if (differenceSeconds <= 59)
      return "$differenceSeconds segundos atrás";

    final int differenceMinutes = now.difference(this.commentedAt).inMinutes;
    if (differenceMinutes <= 59)
      return "$differenceMinutes minutos atrás";

    final int differenceHours = now.difference(this.commentedAt).inHours;
    if (differenceHours <= 23)
      return "$differenceHours minutos atrás";

    final int differenceDays = now.difference(this.commentedAt).inDays;
    if (differenceDays <= 30)
      return "$differenceDays dias atrás";

    return "${this.commentedAt.day.toString().padLeft(2, "0")}/${this.commentedAt.month.toString().padLeft(2, "0")}/${this.commentedAt.year}";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "commentId": commentId,
      "user": user.toMap(),
      "content": content,
      "commentedAt": commentedAt.millisecondsSinceEpoch,
      "totalLikes": totalLikes,
      "isLikedByMe": isLikedByMe,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map["commentId"] as int,
      user: UserModel.fromMap(map["user"] as Map<String,dynamic>),
      content: map["content"] as String,
      commentedAt: DateTime.parse(map["commentedAt"]),
      totalLikes: map["totalLikes"] as int,
      isLikedByMe: map["isLikedByMe"] as bool,
    );
  }

  String toJson() => json.encode(this.toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}