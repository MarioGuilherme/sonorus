enum CreationType {
  post(0),
  product(1),
  opportunity(2);

  final int id;

  const CreationType(this.id);

  static CreationType parse(int id) => values.firstWhere((element) => element.id == id);
}