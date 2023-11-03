class TimeoutException implements Exception {
  final String message;

  TimeoutException({ required this.message });
}