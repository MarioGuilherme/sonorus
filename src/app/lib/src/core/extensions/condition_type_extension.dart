import "package:sonorus/src/domain/enums/condition_type.dart";

extension ConditionTypeExtension on ConditionType {
  String get text => switch (this.id) {
    0 => "Novo",
    1 => "Semi-Usado",
    _ => "Usado"
  };
}