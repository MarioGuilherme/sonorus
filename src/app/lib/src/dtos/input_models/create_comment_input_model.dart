import "dart:convert";

class CreateCommentInputModel {
  final String content;

  CreateCommentInputModel({ required this.content });

  String toJson() => json.encode({ "content": content });
}