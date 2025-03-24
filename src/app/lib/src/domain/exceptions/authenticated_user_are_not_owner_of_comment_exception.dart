class AuthenticatedUserAreNotOwnerOfCommentException implements Exception {
  final String message = "Esse comentário não lhe pertence para você poder modificá-lo!";
}