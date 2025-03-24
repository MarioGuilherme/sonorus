class AuthenticatedUserAreNotOwnerOfOpportunityException implements Exception {
  final String message = "Essa oportunidade não lhe pertence para você poder modificá-la!";
}