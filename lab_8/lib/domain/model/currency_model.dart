class CurrencyModel {
  const CurrencyModel({
    required this.id,
    required this.nominal,
    required this.name,
    required this.symbol,
    required this.value,
    required this.previousValue,
  });

  final String id;
  final int nominal;
  final String name;
  final String symbol;
  final double value;
  final double previousValue;
}
