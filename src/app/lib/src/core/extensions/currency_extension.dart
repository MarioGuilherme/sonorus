import "package:intl/intl.dart";

extension CurrencyExtension on double {
  String get currency {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: "pt_BR",
      symbol: r"R$"
    );
    return currencyFormat.format(this);
  }
}