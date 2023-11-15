import "dart:convert";

class MessageModel {
  String? messageId;
  final String content;
  final bool isSentByMe;
  final DateTime sentAt;
  bool isSent;

  MessageModel({
    this.messageId,
    required this.content,
    required this.isSentByMe,
    required this.sentAt,
    required this.isSent
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "isSentByMe": isSentByMe,
      "content": content,
      "sentAt": sentAt.millisecondsSinceEpoch
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      isSentByMe: map["isSentByMe"] as bool,
      content: map["content"] as String,
      sentAt: DateTime.parse(map["sentAt"]),
      isSent: true
    );
  }

  String toJson() => json.encode(this.toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}