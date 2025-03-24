import "package:sonorus/src/dtos/view_models/chat_view_model.dart";
import "package:sonorus/src/repositories/chat/chat_repository.dart";
import "package:sonorus/src/services/chat/chat_service.dart";

class ChatServiceImpl implements ChatService {
  final ChatRepository _repository;

  ChatServiceImpl(this._repository);

  @override
  Future<List<ChatViewModel>> getAll() => this._repository.getAll();

  @override
  Future<ChatViewModel> getByFriendId(int friendId) => this._repository.getByFriendId(friendId);
}