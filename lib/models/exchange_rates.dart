class ExchangeRates {
  Map<String, double> rates;
  String base;
  String date;

  ExchangeRates({
    required this.rates,
    required this.base,
    required this.date,
  });

  factory ExchangeRates.fromJson(Map<String, dynamic> json) => ExchangeRates(
        rates: Map.from(json["data"])
            .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
        base: "",
        date: DateTime.now().toString(),
      );

  Map<String, dynamic> toJson() => {
        "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "base": base,
        "date": date,
      };
}