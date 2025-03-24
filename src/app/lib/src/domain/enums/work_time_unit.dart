enum WorkTimeUnit {
  perDays(0),
  perHours(1),
  perShow(2);

  final int id;

  const WorkTimeUnit(this.id);

  static WorkTimeUnit parse(int id) => values.firstWhere((element) => element.id == id);
}