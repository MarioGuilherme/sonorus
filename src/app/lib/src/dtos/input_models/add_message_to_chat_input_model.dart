import "dart:convert";

class AddMessageToChatInputModel {
  final String? chatId;
  final String messageId;
  final List<int> participants;
  final String content;

  AddMessageToChatInputModel({
    this.chatId,
    required this.messageId,
    required this.participants,
    required this.content
  });

  String toJson() => json.encode({
    "chatId": this.chatId,
    "messageId": this.messageId,
    "participants": this.participants,
    "content": this.content
  });
}