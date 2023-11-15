import "dart:convert";

import "package:sonorus/src/models/message_model.dart";
import "package:sonorus/src/models/user_model.dart";

class ChatModel {
  String? chatId;
  UserModel? friend;
  List<MessageModel>? messages;

  ChatModel({
    this.chatId,
    required this.friend,
    required this.messages
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "chatId": chatId,
      "friend": friend?.toMap(),
      "messages": messages?.map((x) => x.toMap()).toList()
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map["chatId"] == null ? null : map["chatId"] as String,
      friend: map["friend"] == null ? null : UserModel.fromMap(map["friend"] as Map<String,dynamic>),
      messages: map["messages"] == null ? null : List<MessageModel>.from(map["messages"].map((message) => MessageModel.fromMap(message)).toList())
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}