class SentMessageViewModel {
  final String chatId;
  final String messageId;
  final DateTime sentAt;

  SentMessageViewModel({
    required this.chatId,
    required this.messageId,
    required this.sentAt
  });
  
  factory SentMessageViewModel.fromMap(Map<String, dynamic> map) => SentMessageViewModel(
    chatId: map["chatId"] as String,
    messageId: map["messageId"] as String,
    sentAt: DateTime.parse(map["sentAt"] as String)
  );
}