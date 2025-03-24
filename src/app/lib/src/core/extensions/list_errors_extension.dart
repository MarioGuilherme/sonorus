extension ListErrorsExtension on List? {
  String? errorsByFieldName(String fieldName) => this
    ?.where((element) => element.field == fieldName)
    .fold<String?>(null, (previousValue, element) => previousValue == null
      ? element.errors.fold<String?>(null, (previousValueItem, elementItem) => previousValueItem == null ? elementItem.errors : "$previousValueItem$elementItem;\n").toString().trim()
      : "$previousValue\n${element.error}"
    );
}