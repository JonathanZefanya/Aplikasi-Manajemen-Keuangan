import 'package:drift/drift.dart';

@DataClassName('Rekap')
class Rekaps extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Nama Rekap
  TextColumn get name => text()();
  // Tanggal Durasi
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();

  // Database dibuat
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  BoolColumn get isMonthly => boolean()();

  // Jumlah berapa banyak transaksi
  IntColumn get totalTransactions => integer().nullable()();

  // Total, Rata-rata, Sisa jumlah uang transaksi
  IntColumn get totalExpense => integer().nullable()();
  IntColumn get totalIncome => integer().nullable()();
  IntColumn get sisa => integer().nullable()();
  RealColumn get averageExpense => real().nullable()();
  RealColumn get averageIncome => real().nullable()();
}

class CustomRekap {
  DateTime startDate;
  DateTime endDate;

  CustomRekap({
    required this.startDate,
    required this.endDate,
  });
}

class RekapBulanan {
  DateTime startDate;
  DateTime endDate;

  RekapBulanan({
    required this.startDate,
    required this.endDate,
  });
}
