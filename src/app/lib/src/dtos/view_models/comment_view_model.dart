import "package:sonorus/src/dtos/view_models/user_view_model.dart";

class CommentViewModel {
  final int commentId;
  int totalLikes;
  final DateTime commentedAt;
  String content;
  UserViewModel? author;
  bool isLikedByMe;

  CommentViewModel({
    required this.commentId,
    required this.totalLikes,
    required this.commentedAt,
    required this.content,
    this.author,
    required this.isLikedByMe
  });

  factory CommentViewModel.fromMap(Map<String, dynamic> map) => CommentViewModel(
    commentId: map["commentId"] as int,
    totalLikes: map["totalLikes"] as int,
    commentedAt: DateTime.parse(map["commentedAt"] as String),
    content: map["content"] as String,
    author: map["author"] != null ? UserViewModel.fromMap(map["author"]) : null,
    isLikedByMe: map["isLikedByMe"] as bool
  );
}