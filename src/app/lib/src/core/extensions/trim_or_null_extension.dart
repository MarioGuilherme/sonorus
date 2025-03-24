extension TrimOrNullStringExtension on String? {
  String? trimOrNull() => (this?.trim() ?? "").isEmpty ? null : this!.trim();
}