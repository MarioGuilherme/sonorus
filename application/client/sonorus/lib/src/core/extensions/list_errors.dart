extension ListErrors on List? {
  String? errorsByFieldName(String fieldName) => this
      ?.where((element) => element.field == fieldName)
      .fold<String?>(null, (previousValue, element) => previousValue == null ? element.error : "$previousValue\n${element.error}");
}