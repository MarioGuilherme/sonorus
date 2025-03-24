enum InterestType {
  band(0),
  artist(1),
  musicalGenre(2),
  instrument(3);

  final int id;

  const InterestType(this.id);

  static InterestType parse(int id) => values.firstWhere((element) => element.id == id);
}