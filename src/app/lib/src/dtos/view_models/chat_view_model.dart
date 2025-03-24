import "package:sonorus/src/dtos/view_models/message_view_model.dart";
import "package:sonorus/src/dtos/view_models/user_view_model.dart";

class ChatViewModel {
  String? chatId;
  final List<MessageViewModel> messages;
  final List<UserViewModel> participants;

  ChatViewModel({
    this.chatId,
    required this.messages,
    required this.participants
  });

  factory ChatViewModel.fromMap(Map<String, dynamic> map) => ChatViewModel(
    chatId: map["chatId"] as String?,
    messages: List<MessageViewModel>.from(map["messages"].map((x) => MessageViewModel.fromMap(x)).toList()),
    participants: List<UserViewModel>.from(map["participants"].map((x) => UserViewModel.fromMap(x)))
  );
}