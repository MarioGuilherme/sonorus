class RefreshTokenNotFoundException implements Exception {
  final String message = "Refresh token não encontrado na base de dados!";
}