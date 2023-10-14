import "dart:convert";

import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/media_model.dart";
import "package:sonorus/src/models/user_model.dart";

class PostModel {
  final int postId;
  final UserModel author;
  final String content;
  final DateTime postedAt;
  final List<MediaModel> medias;
  final List<InterestModel> interests;
  final String? tablature;
  int totalComments;
  int totalLikes;
  bool isLikedByMe;

  PostModel({
    required this.postId,
    required this.author,
    required this.content,
    required this.postedAt,
    required this.totalLikes,
    required this.totalComments,
    required this.isLikedByMe,
    required this.medias,
    required this.interests,
    this.tablature,
  });
  
  String get timeAgo {
    final DateTime now = DateTime.now();

    final int differenceSeconds = now.difference(this.postedAt).inSeconds;
    if (differenceSeconds <= 59)
      return "$differenceSeconds segundos atrás";

    final int differenceMinutes = now.difference(this.postedAt).inMinutes;
    if (differenceMinutes <= 59)
      return "$differenceMinutes minutos atrás";

    final int differenceHours = now.difference(this.postedAt).inHours;
    if (differenceHours <= 23)
      return "$differenceHours minutos atrás";

    final int differenceDays = now.difference(this.postedAt).inDays;
    if (differenceDays <= 30)
      return "$differenceDays dias atrás";

    return "${this.postedAt.day.toString().padLeft(2, "0")}/${this.postedAt.month.toString().padLeft(2, "0")}/${this.postedAt.year}";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "postId": postId,
      "author": author.toMap(),
      "content": content,
      "postedAt": postedAt.millisecondsSinceEpoch,
      "totalComments": totalComments,
      "totalLikes": totalLikes,
      "isLikedByMe": isLikedByMe,
      "medias": medias.map((x) => x.toMap()).toList(),
      "interests": interests.map((x) => x.toMap()).toList(),
      "tablature": tablature,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map["postId"] as int,
      author: UserModel.fromMap(map["author"]),
      content: map["content"] as String,
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

  factory PostModel.fromJson(String source) => PostModel.fromMap(json.decode(source) as Map<String, dynamic>);
}