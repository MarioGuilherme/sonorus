import "dart:convert";

import "package:sonorus/src/models/message_model.dart";
import "package:sonorus/src/models/user_model.dart";

class ChatModel {
  final String chatId;
  final UserModel friend;
  final List<MessageModel> messages;

  ChatModel({
    required this.chatId,
    required this.friend,
    required this.messages
  });

  String get lastMessageSentAt {
    final DateTime now = DateTime.now();

    final int differenceSeconds = now.difference(this.messages.first.sentAt).inSeconds;
    if (differenceSeconds <= 59)
      return "$differenceSeconds segundos atrás";

    final int differenceMinutes = now.difference(this.messages.first.sentAt).inMinutes;
    if (differenceMinutes <= 59)
      return "$differenceMinutes minutos atrás";

    final int differenceHours = now.difference(this.messages.first.sentAt).inHours;
    if (differenceHours <= 23)
      return "$differenceHours minutos atrás";

    final int differenceDays = now.difference(this.messages.first.sentAt).inDays;
    if (differenceDays <= 30)
      return "$differenceDays dias atrás";

    return "${this.messages.first.sentAt.day.toString().padLeft(2, "0")}/${this.messages.first.sentAt.month.toString().padLeft(2, "0")}/${this.messages.first.sentAt.year}";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "chatId": chatId,
      "friend": friend.toMap(),
      "messages": messages.map((x) => x.toMap()).toList()
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map["chatId"] as String,
      friend: UserModel.fromMap(map["friend"] as Map<String, dynamic>),
      messages: List<MessageModel>.from(map["messages"].map((message) => MessageModel.fromMap(message)).toList())
    );
  }

  String toJson() => json.encode(this.toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}