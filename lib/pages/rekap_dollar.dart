import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
// import 'package:sisaku/colors.dart';
import 'package:tangan/models/database.dart';
import 'package:tangan/pages/category_page.dart';
import 'package:tangan/pages/detail_rekaps.dart';
import 'package:tangan/pages/home_page.dart';
import 'package:tangan/pages/setting_page.dart';

import 'add+edit_rekap.dart';
import 'gallery_pages.dart';

class RekapDollar extends StatefulWidget {
  final int r;
  const RekapDollar({super.key, required this.r});

  @override
  State<RekapDollar> createState() => _RekapDollarState();
}

class _RekapDollarState extends State<RekapDollar> {
  final AppDb database = AppDb();
  late int r = widget.r;
  late int n;
  bool isUpdate = false;
  // Map<String, double> dataMap = {
  //   "Balance": 253000,
  //   "Belanja Bulanan": 35000,
  //   "Makan dan Minum": 12000,
  // };
  bool datakosong = false;

  late Map<String, double> _dataMap = {};
  late Map<String, double> _pieChartIncExp = {};
  late Map<String, double> _pieChartIncName = {};
  late Map<String, double> _pieChartExpName = {};

  List<String> _list = [
    (lang == 0) ? "Berdasarkan Tipe" : "By Type",
    (lang == 0) ? "Berdasarkan Kategori Pemasukan" : "By Income Category ",
    (lang == 0) ? "Berdasarkan Kategori Pengeluaran" : "By Expense Category",
    (lang == 0) ? "Berdasarkan Semua Transaksi" : "By All Transaction",
  ];
  late String dropDown = _list.first;
  @override
  void initState() {
    super.initState();
    updateR(r);
    updateN(0);
    _loadData();

    getIncExpPieChart().then((dataMapIncExp) {
      setState(() {
        _pieChartIncExp = dataMapIncExp;
      });
    });

    getIncNamePieChart().then((dataMapIncName) {
      setState(() {
        _pieChartIncName = dataMapIncName;
      });
      print("Isi Inc Name $_pieChartIncName");
    });

    getExpNamePieChart().then((dataMapExpName) {
      setState(() {
        _pieChartExpName = dataMapExpName;
      });
      print("Isi Exp Name $_pieChartExpName");
    });

    datamap().then((dataMap) {
      setState(() {
        _dataMap = dataMap;
      });
    });
  }

  void updateR(int index) {
    setState(() {
      r = index;
    });

    isUpdate = false;
  }

  void updateN(int index) {
    setState(() {
      n = index;
    });
  }

  Stream<List<Rekap>> getCustomRekaps() {
    return database.getCustomRekaps();
  }

  Stream<List<Rekap>> getMonthlyRekaps() {
    return database.getMonthlyRekaps();
  }

  Future update(int id, DateTime startDate, DateTime endDate) async {
    return await database.updateRekapAmount(id, startDate, endDate);
  }

  // Future<List<Rekap>> getRekaps() async {
  //   return await database.getRekaps();
  // }

  Future<Map<String, double>> datamap() async {
    final Map<String, double> dataMap = await database.getMapFromDatabase();
    return dataMap;
  }

  Future<Map<String, double>> getIncExpPieChart() async {
    final Map<String, double> dataMapIncExp =
        await database.getIncExpPieChart();
    // print("isi datamap All Inc Exp $dataMapIncExp");
    return dataMapIncExp;
  }

  Future<Map<String, double>> getIncNamePieChart() async {
    final Map<String, double> dataMapInc = await database.getAllIncPieChart();
    print("isi datamap inc name $dataMapInc");
    return dataMapInc;
  }

  Future<Map<String, double>> getExpNamePieChart() async {
    final Map<String, double> dataMapExp = await database.getAllExpPieChart();
    print("isi datamap Exp name $dataMapExp");
    return dataMapExp;
  }

  Future<void> _loadData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
        child: Container(
          color: primary,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            child: Text(
              (lang == 0) ? "Rekap" : "Report",
              style: GoogleFonts.inder(
                fontSize: 23,
                color: base,
              ),
            ),
          ),
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.fromBorderSide(
                                      BorderSide(color: primary)),
                                  color: base,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 5, 0, 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: (r == 1) ? primary : base,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(16),
                                              topLeft: Radius.circular(16),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  updateR(1);
                                                },
                                                child: Text(
                                                  "Realtime",
                                                  style: GoogleFonts.inder(
                                                    color: (r == 1)
                                                        ? base
                                                        : primary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 5, 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: (r == 2) ? primary : base,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  updateR(2);
                                                },
                                                child: Text(
                                                  (lang == 0)
                                                      ? "Bulanan"
                                                      : "Monthly",
                                                  style: GoogleFonts.inder(
                                                    color: (r == 2)
                                                        ? base
                                                        : primary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 5, 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: (r == 3) ? primary : base,
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  updateR(3);
                                                },
                                                child: Text(
                                                  "Custom",
                                                  style: GoogleFonts.inder(
                                                    color: (r == 3)
                                                        ? base
                                                        : primary,
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
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              // Kalo Realtime
                              if (r == 1) ...[
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 20, 20, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              DropdownButton<String>(
                                                dropdownColor: isDark
                                                    ? card
                                                    : Colors.white,
                                                value: dropDown,
                                                elevation: 16,
                                                underline: Container(
                                                  height: 2,
                                                  color: isDark
                                                      ? Colors.white
                                                      : home,
                                                ),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 17,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: isDark
                                                        ? base
                                                        : Colors.black),
                                                onChanged: (String? value) {
                                                  // This is called when the user selects an item.
                                                  setState(() {
                                                    dropDown = value!;
                                                    int index =
                                                        _list.indexOf(value);

                                                    updateN(index);
                                                  });
                                                },
                                                items: _list.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (n == 0) ...[
                                          // ===================================>All Inc Exp Data Map<===================================

                                          // Padding(
                                          //   padding:
                                          //       const EdgeInsets.only(top: 30),
                                          //   child: Text(
                                          //     (lang == 0)
                                          //         ? "Berdasarkan Tipe"
                                          //         : "By Type",
                                          //     style: GoogleFonts.inder(
                                          //       fontSize: 17,
                                          //       color: isDark
                                          //           ? base
                                          //           : Colors.black,
                                          //     ),
                                          //   ),
                                          // ),

                                          FutureBuilder<Map<String, double>>(
                                            future: getIncExpPieChart(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(primary)),
                                                );
                                              } else {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data!.length >
                                                      0) {
                                                    return Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 35),
                                                          child: PieChart(
                                                            dataMap:
                                                                _pieChartIncExp,
                                                            colorList: [
                                                              Colors
                                                                  .greenAccent,
                                                              Colors.redAccent
                                                            ],
                                                            chartRadius:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2,
                                                            legendOptions:
                                                                LegendOptions(
                                                              legendTextStyle:
                                                                  GoogleFonts.inder(
                                                                      color: isDark
                                                                          ? base
                                                                          : home),
                                                              legendPosition:
                                                                  LegendPosition
                                                                      .bottom,
                                                            ),
                                                            chartValuesOptions:
                                                                ChartValuesOptions(
                                                              showChartValuesInPercentage:
                                                                  true,
                                                              decimalPlaces: 0,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 85),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(height: 35),
                                                          Image.asset(
                                                            'assets/img/tes.png',
                                                            width: 200,
                                                          ),
                                                          Text(
                                                            (lang == 0)
                                                                ? "Belum ada transaksi"
                                                                : "No transactions yet",
                                                            style: GoogleFonts
                                                                .inder(
                                                                    color: isDark
                                                                        ? base
                                                                        : home),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 85),
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          'assets/img/tes.png',
                                                          width: 200,
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? "Tidak Ada Data"
                                                              : "No data",
                                                          style:
                                                              GoogleFonts.inder(
                                                                  color: isDark
                                                                      ? base
                                                                      : home),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                        if (n == 1) ...[
                                          // ===================================>All Transaction Inc Name Map<===================================

                                          FutureBuilder<Map<String, double>>(
                                            future: getIncNamePieChart(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center();
                                              } else {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data!.length >
                                                      0) {
                                                    return Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 35),
                                                          child: PieChart(
                                                            dataMap:
                                                                _pieChartIncName,
                                                            chartRadius:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2,
                                                            legendOptions:
                                                                LegendOptions(
                                                              legendTextStyle:
                                                                  GoogleFonts.inder(
                                                                      color: isDark
                                                                          ? base
                                                                          : home),
                                                              legendPosition:
                                                                  LegendPosition
                                                                      .bottom,
                                                            ),
                                                            chartValuesOptions:
                                                                ChartValuesOptions(
                                                              showChartValuesInPercentage:
                                                                  true,
                                                              decimalPlaces: 0,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 85),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(height: 35),
                                                          Image.asset(
                                                            'assets/img/tes.png',
                                                            width: 200,
                                                          ),
                                                          Text(
                                                            (lang == 0)
                                                                ? "Belum ada transaksi"
                                                                : "No transactions yet",
                                                            style: GoogleFonts
                                                                .inder(
                                                                    color: isDark
                                                                        ? base
                                                                        : home),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 85),
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          'assets/img/tes.png',
                                                          width: 200,
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? "Tidak Ada Data"
                                                              : "No data",
                                                          style:
                                                              GoogleFonts.inder(
                                                                  color: isDark
                                                                      ? base
                                                                      : home),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                        if (n == 2) ...[
                                          // ===================================>All Transaction Expense Name Map<===================================

                                          FutureBuilder<Map<String, double>>(
                                            future: getExpNamePieChart(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center();
                                              } else {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data!.length >
                                                      0) {
                                                    return Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 35),
                                                          child: PieChart(
                                                            dataMap:
                                                                _pieChartExpName,
                                                            chartRadius:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2,
                                                            legendOptions:
                                                                LegendOptions(
                                                              legendTextStyle:
                                                                  GoogleFonts.inder(
                                                                      color: isDark
                                                                          ? base
                                                                          : home),
                                                              legendPosition:
                                                                  LegendPosition
                                                                      .bottom,
                                                            ),
                                                            chartValuesOptions:
                                                                ChartValuesOptions(
                                                              showChartValuesInPercentage:
                                                                  true,
                                                              decimalPlaces: 0,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 85),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(height: 35),
                                                          Image.asset(
                                                            'assets/img/tes.png',
                                                            width: 200,
                                                          ),
                                                          Text(
                                                            (lang == 0)
                                                                ? "Belum ada transaksi"
                                                                : "No transactions yet",
                                                            style: GoogleFonts
                                                                .inder(
                                                                    color: isDark
                                                                        ? base
                                                                        : home),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 85),
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          'assets/img/tes.png',
                                                          width: 200,
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? "Tidak Ada Data"
                                                              : "No data",
                                                          style:
                                                              GoogleFonts.inder(
                                                                  color: isDark
                                                                      ? base
                                                                      : home),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                        if (n == 3) ...[
                                          // ===================================>All Transaction Data Map<===================================

                                          FutureBuilder<Map<String, double>>(
                                            future: datamap(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center();
                                              } else {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data!.length >
                                                      0) {
                                                    return Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 35,
                                                                  bottom: 67),
                                                          child: PieChart(
                                                            dataMap: _dataMap,
                                                            chartRadius:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2,
                                                            legendOptions:
                                                                LegendOptions(
                                                              legendTextStyle:
                                                                  GoogleFonts.inder(
                                                                      color: isDark
                                                                          ? base
                                                                          : home),
                                                              legendPosition:
                                                                  LegendPosition
                                                                      .bottom,
                                                            ),
                                                            chartValuesOptions:
                                                                ChartValuesOptions(
                                                              showChartValuesInPercentage:
                                                                  true,
                                                              decimalPlaces: 0,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 85),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(height: 35),
                                                          Image.asset(
                                                            'assets/img/tes.png',
                                                            width: 200,
                                                          ),
                                                          Text(
                                                            (lang == 0)
                                                                ? "Belum ada transaksi"
                                                                : "No transactions yet",
                                                            style: GoogleFonts
                                                                .inder(
                                                                    color: isDark
                                                                        ? base
                                                                        : home),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 85),
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          'assets/img/tes.png',
                                                          width: 200,
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? "Tidak Ada Data"
                                                              : "No data",
                                                          style:
                                                              GoogleFonts.inder(
                                                                  color: isDark
                                                                      ? base
                                                                      : home),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ]

                              // Kalo Bulanan
                              else if (r == 2) ...[
                                Expanded(
                                    child: StreamBuilder<List<Rekap>>(
                                  stream: getMonthlyRekaps(),
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
                                              String startDate = (lang == 0)
                                                  ? DateFormat('dd-MMMM-yyyy',
                                                          'id_ID')
                                                      .format(snapshot
                                                          .data![index]
                                                          .startDate)
                                                  : DateFormat('dd-MMMM-yyyy')
                                                      .format(snapshot
                                                          .data![index]
                                                          .startDate);
                                              String endDate = (lang == 1)
                                                  ? DateFormat('dd-MMMM-yyyy',
                                                          'id_ID')
                                                      .format(snapshot
                                                          .data![index].endDate)
                                                  : DateFormat('dd-MMMM-yyyy',
                                                          'id_ID')
                                                      .format(snapshot
                                                          .data![index]
                                                          .endDate);

                                              while (isUpdate == false) {
                                                update(
                                                    snapshot.data![index].id,
                                                    snapshot
                                                        .data![index].startDate,
                                                    snapshot
                                                        .data![index].endDate);

                                                isUpdate = true;
                                              }
                                              // Update
                                              Future.delayed(
                                                  Duration(seconds: 2));
                                              update(
                                                  snapshot.data![index].id,
                                                  snapshot
                                                      .data![index].startDate,
                                                  snapshot
                                                      .data![index].endDate);
                                              isUpdate = true;

                                              return Column(
                                                children: [
                                                  SizedBox(height: 35),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            (lang == 0)
                                                                ? DateFormat.yMMMM(
                                                                        'id_ID')
                                                                    .format(
                                                                    DateTime.parse(snapshot
                                                                        .data![
                                                                            index]
                                                                        .name),
                                                                  )
                                                                : DateFormat
                                                                        .yMMMM()
                                                                    .format(DateTime.parse(snapshot
                                                                        .data![
                                                                            index]
                                                                        .name)),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: isDark
                                                                    ? base
                                                                    : home),
                                                          ),
                                                          SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.20)
                                                        ],
                                                      ),
                                                      IconButton(
                                                        // Pindah ke halaman Edit Rekap
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            // DetailPage adalah halaman yang dituju
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DetailRekap(
                                                                      rekap: snapshot
                                                                              .data![
                                                                          index]),
                                                            ),
                                                          );
                                                        },
                                                        color: primary,
                                                        hoverColor: secondary,
                                                        icon: Icon(Icons
                                                            .arrow_forward_ios),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          (lang == 0)
                                                              ? "Periode "
                                                              : "Period",
                                                          style: TextStyle(
                                                              color: isDark
                                                                  ? base
                                                                  : home),
                                                        ),
                                                        Text(
                                                          startDate +
                                                              " ~ " +
                                                              endDate,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: isDark
                                                                  ? base
                                                                  : home),
                                                        ),
                                                      ]),
                                                  SizedBox(height: 15),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          (lang == 0)
                                                              ? "Total Pemasukan "
                                                              : "Total Income",
                                                          style: TextStyle(
                                                              color: isDark
                                                                  ? base
                                                                  : home),
                                                        ),
                                                        Text(
                                                          "+ " +
                                                              (NumberFormat
                                                                      .simpleCurrency(
                                                                locale: 'id',
                                                                name: '\$',
                                                                decimalDigits:
                                                                    2,
                                                              ).format((snapshot
                                                                              .data![index]
                                                                              .totalIncome ??
                                                                          0) /
                                                                      16477))
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ]),
                                                  SizedBox(height: 15),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          (lang == 0)
                                                              ? "Total Pengeluaran "
                                                              : "Total Expense",
                                                          style: TextStyle(
                                                              color: isDark
                                                                  ? base
                                                                  : home),
                                                        ),
                                                        Text(
                                                          "+ " +
                                                              (NumberFormat
                                                                      .simpleCurrency(
                                                                locale: 'id',
                                                                name: '\$',
                                                                decimalDigits:
                                                                    2,
                                                              ).format((snapshot
                                                                              .data![index]
                                                                              .totalExpense ??
                                                                          0) /
                                                                      16477))
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      175,
                                                                      36,
                                                                      23)),
                                                        ),
                                                      ]),
                                                  SizedBox(height: 15),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          (lang == 0)
                                                              ? "Sisa "
                                                              : "Balance",
                                                          style: TextStyle(
                                                              color: isDark
                                                                  ? base
                                                                  : home),
                                                        ),
                                                        Text(
                                                          "+ " +
                                                              (NumberFormat
                                                                      .simpleCurrency(
                                                                locale: 'id',
                                                                name: '\$',
                                                                decimalDigits:
                                                                    2,
                                                              ).format((snapshot
                                                                              .data![index]
                                                                              .sisa ??
                                                                          0) /
                                                                      16477))
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: (snapshot
                                                                          .data![
                                                                              index]
                                                                          .sisa! <
                                                                      0)
                                                                  ? Colors
                                                                      .redAccent
                                                                  : primary
                                                              // isDark
                                                              //     ? base
                                                              //     : home

                                                              ),
                                                        ),
                                                      ]),
                                                  SizedBox(height: 30),
                                                ],
                                              )
                                                  .animate()
                                                  .fade(begin: 0.5)
                                                  .then()
                                                  .slideX(begin: 0.7);
                                            },
                                          );
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 85),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 35),
                                                Image.asset(
                                                  'assets/img/tes.png',
                                                  width: 200,
                                                ),
                                                Text(
                                                  (lang == 0)
                                                      ? "Belum ada transaksi pada bulan ini"
                                                      : "No transactions yet this month",
                                                  style: GoogleFonts.inder(
                                                      color:
                                                          isDark ? base : home),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      } else {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 85),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                'assets/img/tes.png',
                                                width: 200,
                                              ),
                                              Text(
                                                (lang == 0)
                                                    ? "Tidak Ada Data"
                                                    : "No data",
                                                style: GoogleFonts.inder(
                                                    color:
                                                        isDark ? base : home),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ))

                                // Kalo Custom
                              ] else if (r == 3) ...[
                                Expanded(
                                    child: StreamBuilder<List<Rekap>>(
                                  stream: getCustomRekaps(),
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
                                              String startDate = (lang == 0)
                                                  ? DateFormat('dd-MMMM-yyyy',
                                                          'id_ID')
                                                      .format(snapshot
                                                          .data![index]
                                                          .startDate)
                                                  : DateFormat('dd-MMMM-yyyy')
                                                      .format(snapshot
                                                          .data![index]
                                                          .startDate);
                                              String endDate = (lang == 1)
                                                  ? DateFormat('dd-MMMM-yyyy',
                                                          'id_ID')
                                                      .format(snapshot
                                                          .data![index].endDate)
                                                  : DateFormat('dd-MMMM-yyyy',
                                                          'id_ID')
                                                      .format(snapshot
                                                          .data![index]
                                                          .endDate);

                                              // Update Jika ada perubahan transaksi
                                              Future.delayed(
                                                  Duration(seconds: 2));
                                              update(
                                                  snapshot.data![index].id,
                                                  snapshot
                                                      .data![index].startDate,
                                                  snapshot
                                                      .data![index].endDate);
                                              isUpdate = true;

                                              return Column(
                                                children: [
                                                  SizedBox(height: 35),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          //     IconButton(onPressed: () {
                                                          //   update(
                                                          //     snapshot.data![index].id,
                                                          //     snapshot
                                                          //         .data![index].startDate,
                                                          //     snapshot
                                                          //         .data![index].endDate);

                                                          // isUpdate = true;
                                                          // }, icon: Icon(Icons.replay_rounded, color: primary)),

                                                          Text(
                                                            snapshot
                                                                .data![index]
                                                                .name
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: isDark
                                                                    ? base
                                                                    : home),
                                                          ),
                                                          SizedBox(width: 35),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            // Pindah ke halaman Detail Rekap
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      DetailRekap(
                                                                          rekap:
                                                                              snapshot.data![index]),
                                                                ),
                                                              );
                                                            },
                                                            color: primary,
                                                            hoverColor:
                                                                secondary,
                                                            icon: Icon(Icons
                                                                .arrow_forward_ios),
                                                          ),
                                                          IconButton(
                                                            // Pindah ke halaman edit
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                // DetailPage adalah halaman yang dituju
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      AddEditRekap(
                                                                          rekap:
                                                                              snapshot.data![index]),
                                                                ),
                                                              );
                                                            },
                                                            color: primary,
                                                            focusColor:
                                                                secondary,
                                                            hoverColor:
                                                                secondary,
                                                            iconSize: 20,
                                                            icon: Icon(
                                                                Icons.edit),
                                                          ),
                                                          IconButton(
                                                              // Pindah ke halaman Detail Rekap
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
                                                                                    (lang == 0) ? 'Yakin ingin Hapus?' : "Are you sure want to delete this recap?",
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
                                                                                        (lang == 0) ? 'Batal' : "Cancel",
                                                                                        style: GoogleFonts.inder(
                                                                                          color: isDark ? base : home,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    ElevatedButton(
                                                                                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(primary)),
                                                                                      onPressed: () {
                                                                                        Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                                        database.deleteRekap(snapshot.data![index].id);
                                                                                        setState(() {});
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: Text(
                                                                                              (lang == 0) ? 'Berhasil Hapus Rekap' : 'Delete Report Success',
                                                                                              style: GoogleFonts.inder(color: base),
                                                                                            ),
                                                                                            backgroundColor: primary,
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                      child: Text(
                                                                                        (lang == 0) ? 'Ya' : "Yes",
                                                                                        style: GoogleFonts.inder(
                                                                                          color: base,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
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
                                                              color: primary,
                                                              focusColor:
                                                                  secondary,
                                                              hoverColor:
                                                                  secondary,
                                                              iconSize: 20,
                                                              icon: Icon(Icons
                                                                  .delete)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          (lang == 0)
                                                              ? "Durasi "
                                                              : "Period",
                                                          style: TextStyle(
                                                              color: isDark
                                                                  ? base
                                                                  : home),
                                                        ),
                                                        Text(
                                                          startDate +
                                                              " ~ " +
                                                              endDate,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: isDark
                                                                  ? base
                                                                  : home),
                                                        ),
                                                      ]),
                                                  SizedBox(height: 15),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          (lang == 0)
                                                              ? "Total Pemasukan "
                                                              : "Total Income",
                                                          style: TextStyle(
                                                              color: isDark
                                                                  ? base
                                                                  : home),
                                                        ),
                                                        Text(
                                                          "+" +
                                                              "Rp." +
                                                              (NumberFormat
                                                                      .currency(
                                                                locale: 'id',
                                                                decimalDigits:
                                                                    0,
                                                              ).format(snapshot
                                                                      .data![
                                                                          index]
                                                                      .totalIncome))
                                                                  .replaceAll(
                                                                      'IDR', '')
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                      ]),
                                                  SizedBox(height: 15),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          (lang == 0)
                                                              ? "Total Pengeluaran "
                                                              : "Total Expense",
                                                          style: TextStyle(
                                                              color: isDark
                                                                  ? base
                                                                  : home),
                                                        ),
                                                        Text(
                                                          "-" +
                                                              "Rp." +
                                                              (NumberFormat
                                                                      .currency(
                                                                locale: 'id',
                                                                decimalDigits:
                                                                    0,
                                                              ).format(snapshot
                                                                      .data![
                                                                          index]
                                                                      .totalExpense))
                                                                  .replaceAll(
                                                                      'IDR', '')
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      175,
                                                                      36,
                                                                      23)),
                                                        ),
                                                      ]),
                                                  SizedBox(height: 15),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          (lang == 0)
                                                              ? "Sisa "
                                                              : " Balance ",
                                                          style: TextStyle(
                                                              color: isDark
                                                                  ? base
                                                                  : home),
                                                        ),
                                                        Text(
                                                          "Rp." +
                                                              (NumberFormat
                                                                      .currency(
                                                                locale: 'id',
                                                                decimalDigits:
                                                                    0,
                                                              ).format(snapshot
                                                                      .data![
                                                                          index]
                                                                      .sisa))
                                                                  .replaceAll(
                                                                      'IDR', '')
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: (snapshot
                                                                          .data![
                                                                              index]
                                                                          .sisa! <
                                                                      0)
                                                                  ? Colors
                                                                      .redAccent
                                                                  : primary),
                                                        ),
                                                      ]),
                                                  SizedBox(height: 30),
                                                ],
                                              )
                                                  .animate()
                                                  .fade(begin: 0.5)
                                                  .then()
                                                  .slideX(begin: 0.7);
                                            },
                                          );
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 85),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 35,
                                                ),
                                                Image.asset(
                                                  'assets/img/tes.png',
                                                  width: 200,
                                                ),
                                                Text(
                                                  (lang == 0)
                                                      ? "Tidak Ada Data"
                                                      : "No data",
                                                  style: GoogleFonts.inder(
                                                      color:
                                                          isDark ? base : home),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      } else {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 85),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                'assets/img/tes.png',
                                                width: 200,
                                              ),
                                              Text(
                                                (lang == 0)
                                                    ? "Tidak Ada Data"
                                                    : "No data",
                                                style: GoogleFonts.inder(
                                                    color:
                                                        isDark ? base : home),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ))
                              ],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Visibility(
                                    visible: (r == 3) ? true : false,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 8, 30),
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            // DetailPage adalah halaman yang dituju
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddEditRekap(rekap: null),
                                            ),
                                          );
                                        },
                                        backgroundColor: primary,
                                        child: Icon(
                                          Icons.add,
                                          color: primary,
                                        )
                                            .animate()
                                            .fade(begin: 0.5)
                                            .tint(color: base)
                                            .shake(duration: 5000.ms),
                                      )
                                          .animate()
                                          .fadeIn(begin: 0.5)
                                          .slideY(begin: 0.7, duration: 500.ms),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ).animate().slideY(begin: 0.2, delay: 70.ms, duration: 400.ms),
      floatingActionButton: (r == 1)
          ? FloatingActionButton.extended(
              backgroundColor: primary,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  // DetailPage adalah halaman yang dituju
                  MaterialPageRoute(
                    builder: (context) => GalleryPage(),
                  ),
                );
              },
              label: Text(
                (lang == 0) ? 'Lihat Galeri' : 'View Gallery',
                style: GoogleFonts.inder(
                  color: base,
                ),
              ),
            ).animate().fade().slideY(begin: -1, delay: 70.ms, duration: 400.ms)
          : Center(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: primary,
    );
  }
}
