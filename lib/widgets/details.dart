import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

// import 'package:sisaku/colors.dart';
import 'package:tangan/pages/setting_page.dart';

class Details extends StatefulWidget {
  const Details({
    super.key,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.totalExpense,
    required this.dailyAverage,
    required this.balance,
    required this.isMonthly,
  });
  // final Rekap? rekap;
  final name;
  final startDate;
  final endDate;
  final totalIncome;
  final totalExpense;
  final dailyAverage;
  final balance;
  final isMonthly;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 35),
      Text(
        (lang == 0)
            ? (widget.isMonthly)
                ? DateFormat.yMMMM('id_ID').format(
                    DateTime.parse(widget.name),
                  )
                : widget.name
            : (widget.isMonthly)
                ? DateFormat.yMMMM().format(DateTime.parse(widget.name))
                : widget.name,
        style:
            TextStyle(fontWeight: FontWeight.bold, color: isDark ? base : home),
      ),
      SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          (lang == 0) ? "Periode " : "Period",
          style: TextStyle(
                                                         fontWeight: FontWeight.w800,
                                                              color: isDark
                                                                  ? base
                                                                  : home),
        ),
        Text(
          (lang == 0)
              ? DateFormat('dd-MMMM-yyyy', 'id_ID')
                      .format(widget.startDate)
                      .toString() +
                  " ~ " +
                  DateFormat('dd-MMMM-yyyy', 'id_ID')
                      .format(widget.endDate)
                      .toString()
              : DateFormat('dd-MMMM-yyyy').format(widget.startDate).toString() +
                  " ~ " +
                  DateFormat('dd-MMMM-yyyy').format(widget.endDate).toString(),
          style: TextStyle(fontWeight: FontWeight.w800,
          color: isDark ? base : home),
        ),
      ]),
      SizedBox(height: 15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          (lang == 0) ? "Total Pemasukan " : "Total Income",
          style: TextStyle(color: isDark ? base : home),
        ),
        Text(
           "+ " + "Rp." +
              (NumberFormat.currency(
                locale: 'id',
                decimalDigits: 0,
              ).format(
                widget.totalIncome,
              )).replaceAll('IDR', ''),
          style: TextStyle(
                                                              fontWeight: FontWeight.w700,

                                                              color: Colors.green),
        ),
      ]),
      SizedBox(height: 15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          (lang == 0) ? "Total Pengeluaran " : "Total Expense",
          style: TextStyle(color: isDark ? base : home),
        ),
        Text(
            "- " +"Rp." +
              (NumberFormat.currency(
                locale: 'id',
                decimalDigits: 0,
              ).format(
                widget.totalExpense,
              )).replaceAll('IDR', ''),
          style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                              color: Color.fromARGB(255, 175, 36, 23)),
        ),
      ]),
      SizedBox(height: 15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          (lang == 0) ? "Rata-Rata Harian " : "Daily Average",
          style: TextStyle(color: isDark ? base : home),
        ),
        Text(
          ((widget.totalIncome > widget.totalExpense) ? '+' : '-') + "Rp." +
              (NumberFormat.currency(
                locale: 'id',
                decimalDigits: 0,
              ).format(
                widget.dailyAverage,
              )).replaceAll('IDR', ''),
          style: TextStyle(
             fontWeight: FontWeight.w700,
             color: isDark ? base : home),
        ),
      ]),
      SizedBox(height: 15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          (lang == 0) ? "Sisa " : "Balance",
          style: TextStyle(
            fontWeight:FontWeight.w700,
            color: isDark ? base : home
           ),
        ),
        Text(
          "Rp." +
              (NumberFormat.currency(
                locale: 'id',
                decimalDigits: 0,
              ).format(
                widget.balance,
              )).replaceAll('IDR', ''),
          style: TextStyle(
            fontWeight:FontWeight.w700,
            color:  (widget.balance < 0) ? Colors.redAccent: primary),
        ),
      ]),
      SizedBox(height: 27)
    ]).animate().fade().slideX(duration: 300.ms);
  }
}
