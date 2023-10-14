import "package:sonorus/src/models/chat_model.dart";

abstract interface class ChatService {
  Future<List<ChatModel>> getChats();
}