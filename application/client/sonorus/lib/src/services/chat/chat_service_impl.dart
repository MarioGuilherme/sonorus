import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/repositories/chat/chat_repository.dart";
import "package:sonorus/src/services/chat/chat_service.dart";

class ChatServiceImpl implements ChatService {
  final ChatRepository _chatRepository;

  ChatServiceImpl(this._chatRepository);

  @override
  Future<List<ChatModel>> getChats() async => this._chatRepository.getChats();
}