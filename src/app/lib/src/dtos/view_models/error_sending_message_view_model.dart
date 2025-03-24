class ErrorSendingMessageViewModel {
  final String? messageId;
  final List<String> errors;

  ErrorSendingMessageViewModel({
    required this.messageId,
    required this.errors
  });

  factory ErrorSendingMessageViewModel.fromMap(Map<String, dynamic> map) => ErrorSendingMessageViewModel(
    messageId: map["messageId"] as String?,
    errors: List<String>.from(map["errors"].map((e) => e as String)),
  );
}