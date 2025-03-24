import "dart:convert";

class UpdateCommentInputModel {
  final String content;

  UpdateCommentInputModel({ required this.content });

  String toJson() => json.encode({ "content": content });
}