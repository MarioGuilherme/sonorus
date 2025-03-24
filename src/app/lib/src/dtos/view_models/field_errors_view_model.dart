class FieldErrorsViewModel {
  final String field;
  final List<String> errors;

  FieldErrorsViewModel({ required this.field, required this.errors });

  factory FieldErrorsViewModel.fromMap(Map<String, dynamic> map) => FieldErrorsViewModel(
    field: map["field"] as String,
    errors: List<String>.from(map["errors"].map((e) => e as String))
  );
}