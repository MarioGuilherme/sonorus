enum ConditionType {
  new_(0),
  semiUsed(1),
  used(2);

  final int id;

  const ConditionType(this.id);

  static ConditionType parse(int id) => values.firstWhere((element) => element.id == id);
}