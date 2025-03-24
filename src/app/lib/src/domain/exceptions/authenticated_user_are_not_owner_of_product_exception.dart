class AuthenticatedUserAreNotOwnerOfProductException implements Exception {
  final String message = "Esse anúncio não lhe pertence para você poder modificá-lo!";
}