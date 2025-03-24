class AuthenticatedUserAreNotOwnerOfPostException implements Exception {
  final String message = "Essa publicação não lhe pertence para você poder modificá-lo!";
}