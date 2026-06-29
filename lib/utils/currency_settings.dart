import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tangan/models/currency.dart';

class CurrencySettings {
  static const String baseCode = 'IDR';
  static const String _selectedCodeKey = 'selected_currency_code';
  static const String _ratesKey = 'currency_rates_cache';
  static const String _lastUpdateKey = 'currency_rates_last_update';

  static String selectedCode = baseCode;
  static Map<String, double> rates = {baseCode: 1};
  static String lastUpdate = '';

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    selectedCode = prefs.getString(_selectedCodeKey) ?? baseCode;
    lastUpdate = prefs.getString(_lastUpdateKey) ?? '';

    final ratesJson = prefs.getString(_ratesKey);
    if (ratesJson != null) {
      final decoded = jsonDecode(ratesJson) as Map<String, dynamic>;
      rates = decoded.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      );
    }
    rates[baseCode] = 1;
  }

  static Future<void> saveSelectedCurrency(Currency currency) async {
    selectedCode = currency.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedCodeKey, selectedCode);
  }

  static Future<void> refreshRates() async {
    final response = await Dio().get(
      'https://open.er-api.com/v6/latest/$baseCode',
    );
    final data = response.data as Map<String, dynamic>;
    final result = data['result']?.toString().toLowerCase();
    if (result != 'success') {
      throw Exception(data['error-type'] ?? 'Gagal memperbarui kurs');
    }

    final fetchedRates = (data['rates'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );
    fetchedRates[baseCode] = 1;

    rates = fetchedRates;
    lastUpdate = data['time_last_update_utc']?.toString() ??
        DateTime.now().toIso8601String();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ratesKey, jsonEncode(rates));
    await prefs.setString(_lastUpdateKey, lastUpdate);
  }

  static Future<void> ensureRates() async {
    await load();
    if (selectedCode == baseCode || rates.containsKey(selectedCode)) return;
    await refreshRates();
  }

  static Currency selectedCurrency() {
    return getDataCurrency().firstWhere(
      (currency) => currency.value == selectedCode,
      orElse: () => getDataCurrency().firstWhere(
        (currency) => currency.value == baseCode,
      ),
    );
  }

  static double convert(num amount, {String? toCode}) {
    final targetCode = toCode ?? selectedCode;
    final rate = rates[targetCode] ?? 1;
    return amount.toDouble() * rate;
  }

  static String format(num amount, {bool withSign = false}) {
    final convertedAmount = convert(amount).abs();
    final symbol = selectedCode == baseCode ? 'Rp ' : '$selectedCode ';
    final decimalDigits = selectedCode == baseCode ? 0 : 2;
    final formatted = NumberFormat.currency(
      locale: 'en_US',
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(convertedAmount);

    if (!withSign) return formatted;
    if (amount > 0) return '+$formatted';
    if (amount < 0) return '-$formatted';
    return formatted;
  }
}

String formatMoney(num amount, {bool withSign = false}) {
  return CurrencySettings.format(amount, withSign: withSign);
}
