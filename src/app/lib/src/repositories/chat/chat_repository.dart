import "package:sonorus/src/dtos/view_models/chat_view_model.dart";

abstract interface class ChatRepository {
  Future<List<ChatViewModel>> getAll();
  Future<ChatViewModel> getByFriendId(int friendId);
}