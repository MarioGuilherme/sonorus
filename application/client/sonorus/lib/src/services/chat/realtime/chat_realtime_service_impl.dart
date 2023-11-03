import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/models/message_model.dart";
import "package:sonorus/src/repositories/chat/realtime/chat_realtime_repository.dart";
import "package:sonorus/src/services/chat/realtime/chat_realtime_service.dart";

class ChatRealtimeServiceImpl implements ChatRealtimeService {
  final ChatRealtimeRepository _chatRealtimeRepository;

  ChatRealtimeServiceImpl(this._chatRealtimeRepository);

  @override
  Future<List<MessageModel>> getMessages(String chatId) async => this._chatRealtimeRepository.getMessages(chatId);
  
  @override
  Future<List<MessageModel>> getMessagesByFriendId(int friendId) async => this._chatRealtimeRepository.getMessagesByFriendId(friendId);
}