class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException({ required this.message });
}