class EmailOrNicknameInUseException implements Exception {
  final String message;

  EmailOrNicknameInUseException({ required this.message });
}