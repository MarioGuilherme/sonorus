// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:sonorus/src/models/form_error_model.dart";

class InvalidCredentialsException implements Exception {
  final String message;
  final List<FormErrorModel> errors;

  InvalidCredentialsException({ required this.errors, required this.message });
}
