import "package:sonorus/src/models/chat_model.dart";

abstract interface class ChatRepository {
  Future<List<ChatModel>> getChats();
}