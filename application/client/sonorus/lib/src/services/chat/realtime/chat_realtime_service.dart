import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/models/message_model.dart";

abstract interface class ChatRealtimeService {
  Future<List<MessageModel>> getMessages(String chatId);
  Future<List<MessageModel>> getMessagesByFriendId(int friendId);
}