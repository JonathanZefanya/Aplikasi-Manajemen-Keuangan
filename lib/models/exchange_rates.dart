class ExchangeRates {
  Map<String, double> rates;
  String base;
  String date;

  ExchangeRates({
    required this.rates,
    required this.base,
    required this.date,
  });

  factory ExchangeRates.fromJson(Map<String, dynamic> json) {
    final updateUnix = json["time_last_update_unix"];
    final updateDate = updateUnix is num
        ? DateTime.fromMillisecondsSinceEpoch(
            updateUnix.toInt() * 1000,
            isUtc: true,
          ).toIso8601String()
        : DateTime.now().toIso8601String();

    return ExchangeRates(
      rates: Map.from(json["rates"])
          .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      base: json["base_code"] ?? "USD",
      date: updateDate,
    );
  }

  Map<String, dynamic> toJson() => {
        "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "base": base,
        "date": date,
      };
}
