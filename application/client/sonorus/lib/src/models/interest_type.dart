enum InterestType {
  bandOrArtist(0),
  musicalGenre(1),
  instrument(2);

  final int id;

  const InterestType(this.id);

  static InterestType parse(int id) => values.firstWhere((element) => element.id == id);
}