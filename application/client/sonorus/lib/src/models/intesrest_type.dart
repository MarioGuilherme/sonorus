enum InterestType {
  band(0),
  musicalGenre(1),
  skill(2);

  final int id;

  const InterestType(this.id);

  static InterestType parse(int id) => values.firstWhere((element) => element.id == id);
}