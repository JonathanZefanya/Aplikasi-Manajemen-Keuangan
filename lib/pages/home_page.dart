import 'dart:typed_data';

// import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
// import 'package:tangan/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tangan/models/database.dart';
import 'package:tangan/models/transaction_with_category.dart';
import 'package:tangan/pages/category_page.dart';
import 'package:tangan/pages/rekap_page.dart';
import 'package:tangan/pages/setting_page.dart';
import 'package:tangan/pages/transaction_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

bool isLoading = true;

class HomePage extends StatefulWidget {
  final DateTime selectedDate;
  const HomePage({
    required this.selectedDate,
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDb database = AppDb();

  int totalAmount1 = 0;
  int totalAmount2 = 0;
  int rest = 0;
  int result1 = 0;
  int result2 = 0;
  late DateTime selectedDate = widget.selectedDate;

  void initState() {
    initializeDateFormatting();
    print(selectedDate);
    updateView(selectedDate);
    print(selectedDate);
    _loadData();
    loadData();
    if (isLoading) {
      Future.delayed(Duration(milliseconds: 2300), () {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
    super.initState();
  }

  Future<void> _loadData() async {
    final type1 = 1;
    final type1Count = await database.countType(type1);

    if (type1Count > 0) {
      result1 = await database.getTotalAmountForTypeAndDate(type1);
    }

    final type2 = 2;
    final type2Count = await database.countType(type2);

    if (type2Count > 0) {
      result2 = await database.getTotalAmountForTypeAndDate(type2);
    }

    setState(() {
      totalAmount1 = result1;
      totalAmount2 = result2;
      rest = totalAmount1 - totalAmount2;
    });
  }

  void updateView(DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(
          DateFormat('yyyy-MM-dd').format(date),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: (SchedulerBinding
                          .instance.platformDispatcher.platformBrightness ==
                      Brightness.dark)
                  ? background
                  : Colors.white,
              child: Center(
                child: Container(
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        LoadingAnimationWidget.discreteCircle(
                          color: defaultTheme[0],
                          size: 160,
                          secondRingColor: defaultTheme[1],
                          thirdRingColor: defaultTheme[4],
                        ).animate().fadeIn(duration: 500.ms),
                        Positioned(
                            child: Image.asset(
                          'assets/img/logo.png',
                          width: 100,
                        ))
                      ],
                    )),
              ),
            ),
          ).animate().fadeOut(delay: 1000.ms, duration: 1250.ms)
        : Scaffold(
            appBar: PreferredSize(
              preferredSize:
              // Atur page Calendar home
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.50),
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
                child: CalendarCarousel<Event>(
                  onDayPressed: (date, events) {
                    this.setState(() => selectedDate = date);
                    events.forEach((event) => print(event.title));
                  },
                  daysTextStyle: GoogleFonts.inder(
                    color: home,
                    fontSize: 18,
                  ),
                  weekendTextStyle: GoogleFonts.inder(color: base),
                  thisMonthDayBorderColor: base,
                  headerTextStyle: GoogleFonts.inder(
                    color: base,
                    fontSize: 20,
                  ),
                  iconColor: base,
                  weekFormat: true,
                  showWeekDays: true,
                  weekdayTextStyle:
                      GoogleFonts.inder(fontSize: 18, color: base),
                  locale: (lang == 0) ? 'id' : 'en',
                  // Atur Page Putih-Putih
                  height: 205.0,
                  selectedDateTime: selectedDate,
                  showIconBehindDayText: true,
                  customGridViewPhysics: NeverScrollableScrollPhysics(),
                  markedDateShowIcon: true,
                  firstDayOfWeek: 1,
                  pageSnapping: true,
                  todayTextStyle: GoogleFonts.inder(color: Colors.black),
                  markedDateIconMaxShown: 2,
                  headerText: (lang == 0)
                      ? '${DateFormat.yMMM('id_ID').format(selectedDate)}'
                      : '${DateFormat.yMMM().format(selectedDate)}',
                  selectedDayTextStyle: GoogleFonts.inder(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  selectedDayBorderColor: base,
                  selectedDayButtonColor: base,
                  nextMonthDayBorderColor: base,
                  minSelectedDate:
                      DateTime.now().subtract(Duration(days: 365 * 4)),
                  maxSelectedDate: DateTime.now().add(Duration(days: 100)),
                  todayButtonColor: Colors.transparent,
                  todayBorderColor: base,
                  markedDateMoreShowTotal: true,
                  nextDaysTextStyle: GoogleFonts.inder(color: base),
                  prevDaysTextStyle: GoogleFonts.inder(color: home),
                ).animate().fade().slide(duration: 400.ms),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? background : base,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18, 20, 16, 5),
                              child: Text(
                                (lang == 0)
                                    ? 'Sisa Uang Kamu : Rp. ' +
                                        (NumberFormat.currency(
                                          locale: 'id',
                                          decimalDigits: 0,
                                        ).format(
                                          rest,
                                        )).replaceAll('IDR', '')
                                    : 'Balance : Rp. ' +
                                        (NumberFormat.currency(
                                          locale: 'id',
                                          decimalDigits: 0,
                                        ).format(
                                          rest,
                                        )).replaceAll('IDR', ''),
                                style: GoogleFonts.inder(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: isDark ? base : Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: isDark ? card : home,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.download_outlined,
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (lang == 0)
                                                  ? 'Pemasukan'
                                                  : 'Income',
                                              style: GoogleFonts.inder(
                                                color: base,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Rp. ' +
                                                  (NumberFormat.currency(
                                                    locale: 'id',
                                                    decimalDigits: 0,
                                                  ).format(
                                                    totalAmount1,
                                                  )).replaceAll('IDR', ''),
                                              style: GoogleFonts.inder(
                                                color: base,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.upload_outlined,
                                            color: Colors.red,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (lang == 0)
                                                  ? 'Pengeluaran'
                                                  : 'Expense',
                                              style: GoogleFonts.inder(
                                                color: base,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Rp. ' +
                                                  (NumberFormat.currency(
                                                    locale: 'id',
                                                    decimalDigits: 0,
                                                  ).format(
                                                    totalAmount2,
                                                  )).replaceAll('IDR', ''),
                                              style: GoogleFonts.inder(
                                                color: base,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //text transaksi
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (lang == 0) ? 'Transaksi' : 'Transactions',
                                    style: GoogleFonts.inder(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? base : Colors.black,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RekapPage(
                                            r: 1,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      (lang == 0) ? 'Lihat Semua' : 'View All',
                                      style: GoogleFonts.inder(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w200,
                                        color: isDark ? base : Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: StreamBuilder<
                                    List<TransactionWithCategory>>(
                                  stream: database
                                      .getTransactionByDate(selectedDate),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    primary)),
                                      );
                                    } else {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.length > 0) {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  child: SingleChildScrollView(
                                                    child: Card(
                                                      color:
                                                          isDark ? card : base,
                                                      elevation: 10,
                                                      child: ListTile(
                                                        leading: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: isDark
                                                                ? card
                                                                : base,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: (snapshot
                                                                      .data![
                                                                          index]
                                                                      .transaction
                                                                      .image !=
                                                                  null)
                                                              ? Image.memory(
                                                                  snapshot
                                                                          .data![
                                                                              index]
                                                                          .transaction
                                                                          .image ??
                                                                      Uint8List(
                                                                          0),
                                                                  // width: 80,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  width: 80,
                                                                  height: 50,
                                                                )
                                                              : Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: 80,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10),
                                                                          color: Color.fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0.1)),
                                                                      child: snapshot.data![index].category.type ==
                                                                              2
                                                                          ? Icon(
                                                                              Icons.upload_rounded,
                                                                              color: Colors.red,
                                                                              size: 40,
                                                                            )
                                                                          : Icon(
                                                                              Icons.download_rounded,
                                                                              color: Colors.green,
                                                                              size: 40,
                                                                            ),
                                                                    ),
                                                                  ],
                                                                ),
                                                        ),
                                                        title: Text(
                                                          'Rp. ' +
                                                              (NumberFormat
                                                                  .currency(
                                                                locale: 'id',
                                                                decimalDigits:
                                                                    0,
                                                              ).format(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .transaction
                                                                    .amount,
                                                              )).replaceAll(
                                                                  'IDR', ''),
                                                          style: TextStyle(
                                                              color: isDark
                                                                  ? base
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                        subtitle: Text(
                                                          snapshot
                                                                  .data![index]
                                                                  .transaction
                                                                  .name +
                                                              ' ~ ' +
                                                              snapshot
                                                                  .data![index]
                                                                  .category
                                                                  .name,
                                                          style: TextStyle(
                                                              color: isDark
                                                                  ? base
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                        trailing: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons.delete,
                                                                color: isDark
                                                                    ? base
                                                                    : home,
                                                              ),
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        backgroundColor: isDark
                                                                            ? dialog
                                                                            : Colors.white,
                                                                        shadowColor:
                                                                            Colors.red[50],
                                                                        content:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Center(
                                                                                  child: Text(
                                                                                    (lang == 0) ? 'Yakin ingin Hapus?' : 'Are you sure want to delete this transaction?',
                                                                                    style: GoogleFonts.inder(
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: isDark ? base : Colors.black,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 30,
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.of(context).pop();
                                                                                      },
                                                                                      child: Text(
                                                                                        (lang == 0) ? 'Batal' : 'Cancel',
                                                                                        style: TextStyle(
                                                                                          color: isDark ? base : Colors.black,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    ElevatedButton(
                                                                                      style: ButtonStyle(
                                                                                        backgroundColor: MaterialStatePropertyAll(primary),
                                                                                      ),
                                                                                      onPressed: () async {
                                                                                        // Navigator.of(
                                                                                        //         context,
                                                                                        //         rootNavigator:
                                                                                        //             true)
                                                                                        //     .pop();
                                                                                        await database.deleteTransactionRepo(snapshot.data![index].transaction.id);
                                                                                        // Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                                        Navigator.of(context).pushReplacement(
                                                                                          MaterialPageRoute(
                                                                                            builder: (context) => HomePage(selectedDate: selectedDate),
                                                                                          ),
                                                                                        );
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(
                                                                                              content: Text(
                                                                                                (lang == 0) ? 'Berhasil Hapus Transaksi' : 'Delete Transaction Success',
                                                                                                style: GoogleFonts.inder(color: base),
                                                                                              ),
                                                                                              backgroundColor: primary),
                                                                                        );

                                                                                        setState(() {});
                                                                                      },
                                                                                      child: Text(
                                                                                        (lang == 0) ? 'Ya' : 'Yes',
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                            ),
                                                            // SizedBox(
                                                            //   width: 1,
                                                            // ),
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons.edit,
                                                                color: isDark
                                                                    ? base
                                                                    : home,
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        ((context) =>
                                                                            TransactionPage(
                                                                              transactionWithCategory: snapshot.data![index],
                                                                            )),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // Animasi Card
                                                    )
                                                        .animate()
                                                        .fade(begin: 0.5)
                                                        .then()
                                                        .slideX(begin: 0.7),
                                                  ),
                                                );
                                              });
                                        } else {
                                          return Center(
                                            child: Text(
                                              (lang == 0)
                                                  ? 'Belum ada transaksi'
                                                  : 'No transaction yet',
                                              style: TextStyle(
                                                color: isDark ? base : home,
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        return Center(
                                          child: Text(
                                            (lang == 0)
                                                ? 'Tidak ada data'
                                                : "No data",
                                            style: TextStyle(
                                              color: isDark ? base : home,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: primary,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        TransactionPage(transactionWithCategory: null),
                  ),
                );
              },
              backgroundColor: primary,
              child: Icon(
                Icons.add,
                size: 27,
                color: primary,
                // Animasi Icon
              )
                  .animate()
                  .fade(begin: 0.5)
                  .tint(color: base)
                  .shake(duration: 5000.ms),
              // animasi Floating Action Button
            ).animate().fadeIn(begin: 0.5).slideY(begin: 0.7, duration: 500.ms),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              color: isDark ? dialog : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.home,
                        color: primary,
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.list,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),

                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => RekapPage(
                              r: 1,
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.bar_chart,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => SettingPage(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.settings,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
