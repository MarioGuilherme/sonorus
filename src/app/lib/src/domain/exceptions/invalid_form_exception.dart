import "package:dio/dio.dart";

import "package:sonorus/src/dtos/view_models/field_errors_view_model.dart";

class InvalidFormException implements Exception {
  final String message = "Alguns campos estão inválidos!";
  final List<FieldErrorsViewModel> errors;
  
  String? get errorsConcatened => this.errors.fold("", (previousValue, element) => "$previousValue${element.errors.fold("", (previousValueItem, elementItem) => "$previousValueItem$elementItem;\n")}").trim();

  InvalidFormException(this.errors);

  String? errorsByFieldName(String fieldName) => this.errors
    .where((error) => error.field == fieldName)
    .fold("", (previousValue, element) => "$previousValue${element.errors.fold("", (previousValueItem, elementItem) => "$previousValueItem$elementItem;\n")}").trim();

  factory InvalidFormException.fromResponse(Response<dynamic> response) {
    final List<FieldErrorsViewModel> fieldErrors = List<FieldErrorsViewModel>.from(response.data.map((error) => FieldErrorsViewModel.fromMap(error)).toList());
    return InvalidFormException(fieldErrors);
  }
}