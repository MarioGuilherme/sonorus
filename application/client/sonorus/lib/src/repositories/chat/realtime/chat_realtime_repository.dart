import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/models/message_model.dart";

abstract interface class ChatRealtimeRepository {
  Future<List<MessageModel>> getMessages(String chatId);
}