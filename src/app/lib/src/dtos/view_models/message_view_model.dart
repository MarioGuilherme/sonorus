class MessageViewModel {
  String? messageId;
  final String content;
  final int sentByUserId;
  DateTime? sentAt;

  MessageViewModel({
    this.messageId,
    required this.content,
    required this.sentByUserId,
    this.sentAt
  });

  factory MessageViewModel.fromMap(Map<String, dynamic> map) => MessageViewModel(
    content: map["content"] as String,
    sentByUserId: map["sentByUserId"] as int,
    sentAt: DateTime.parse(map["sentAt"] as String)
  );
}