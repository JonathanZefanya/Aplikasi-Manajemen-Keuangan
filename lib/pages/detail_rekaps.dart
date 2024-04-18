import 'dart:io';
import 'dart:typed_data';
// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
// import 'package:open_document/my_files/init.dart';
// import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tangan/pages/category_page.dart';
import 'package:tangan/pages/gallery_rekap_pages.dart';
import 'package:tangan/pages/home_page.dart';
import 'package:tangan/pages/rekap_page.dart';
import 'package:tangan/pages/setting_page.dart';
import 'package:tangan/models/database.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tangan/pages/transaction_page.dart';
import 'package:tangan/widgets/details.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart ' as xlsio;
// import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../models/transaction_with_category.dart';
// import 'gallery_pages.dart';

// import 'package:open_document/open_document.dart';
// import 'package:open_file_plus/open_file_plus.dart';

class DetailRekap extends StatefulWidget {
  const DetailRekap({super.key, required this.rekap});
  final Rekap? rekap;

  @override
  State<DetailRekap> createState() => _DetailRekapsStat();
}

class _DetailRekapsStat extends State<DetailRekap>
    with SingleTickerProviderStateMixin {
  final AppDb database = AppDb();
  late int r;

  // Data Detail Rekap dari Rekap yang dipilih
  late int id;
  late String name;
  late String startDate;
  late String endDate;
  late var dbStartDate;
  late var dbEndDate;
  late var totalExpense;
  late var totalIncome;
  late var averageIncome;
  late var averageExpense;
  late int totalTransactions;
  late var balance;
  late bool isMonthly;
  late double dailyAverage;

  // Untuk Export ke Excel
  late var expenseCategory;
  late var incomeCategory;
  late var rekapTransactions;
  late String filePath;
  // Untuk dapetin categoi
  late var getCategory;
  // Tab
  late int n;
  late TabController _tabController;

  List<String> _list = [
    (lang == 0) ? "Berdasarkan Tipe" : "By Type",
    (lang == 0) ? "Berdasarkan Kategori Pemasukan" : "By Income Category ",
    (lang == 0) ? "Berdasarkan Kategori Pengeluaran" : "By Expense Category",
    (lang == 0) ? "Berdasarkan Semua Transaksi" : "By All Transaction",
  ];

  late String dropDown = _list.first;
  final _selectedColor = primary;
  // final _unselectedColor = base;

  final _tabs = [
    Tab(text: (lang == 0) ? 'Grafik' : "Chart"),
    Tab(text: (lang == 0) ? 'Kategori' : "Category"),
    Tab(text: (lang == 0) ? 'Nama' : "Name"),
  ];
  late bool isUpdate = false;

  late Map<String, double> _allTransactionPieChart = {};
  late Map<String, double> _pieChartIncExp = {};
  late Map<String, double> _pieChartIncName = {};
  late Map<String, double> _pieChartExpName = {};

  // final _iconTabs = const [
  //   Tab(icon: Icon(Icons.home)),
  //   Tab(icon: Icon(Icons.search)),
  //   Tab(icon: Icon(Icons.settings)),
  // ];

  Future<void> _loadData() async {
    setState(() {});
  }

  void updateRekapView(Rekap rekap) {
    id = rekap.id;
    name = rekap.name;
    print("Ini startDate :" + rekap.startDate.toString());

    startDate = DateFormat('dd-MMMM-yyyy').format(rekap.startDate);
    endDate = DateFormat('dd-MMMM-yyyy').format(rekap.endDate);

    // Untuk Query
    dbStartDate = rekap.startDate;
    dbEndDate = rekap.endDate;
    totalTransactions = rekap.totalTransactions!;
    totalExpense = rekap.totalExpense;
    totalIncome = rekap.totalIncome;
    averageIncome = rekap.totalIncome;
    averageExpense = rekap.totalExpense;
    balance = rekap.sisa;
    isMonthly = rekap.isMonthly;
    print('ini id $id');
  }

//  getCategoryNameByRekaps

  double getDailyAverage(int totalExpense, int totalIncome) {
    dailyAverage = (totalExpense + totalIncome) / totalTransactions;
    return dailyAverage;
  }

  void updateR(int index) {
    setState(() {
      r = index + 1;
    });
  }

  // Kalkulasi persen berdasarkan kategori
  double calculatePercentage(double categoryAmount, double totalAmount) {
    if (totalAmount > 0) {
      return categoryAmount / totalAmount;
    } else {
      return 0.0;
    }
  }

  double totalExpenseAmounts = 0;
  double totalIncomeAmounts = 0;

  // Get All transaction for Piechart
  Future<Map<String, double>> getRekapType(DateTime start, DateTime end) async {
    final Map<String, double> dataMap =
        await database.getRekapIncExpPieChart(start, end);
    return dataMap;
  }

  // Get Income Name for Piechart
  Future<Map<String, double>> getIncNamePieChart(
      DateTime start, DateTime end) async {
    final Map<String, double> dataMap =
        await database.getRekapIncPieChart(start, end);
    return dataMap;
  }

  // Get Expense for Piechart
  Future<Map<String, double>> getExpNamePieChart(
      DateTime start, DateTime end) async {
    final Map<String, double> dataMap =
        await database.getRekapExpPieChart(start, end);
    return dataMap;
  }

  // Get All transaction for Piechart
  Future<Map<String, double>> getAllTransactions(
      DateTime start, DateTime end) async {
    final Map<String, double> dataMap =
        await database.getTransactionRekapPieChart(start, end);
    return dataMap;
  }

// =============================> load Data, Etc <=============================
  @override
  void initState() {
    if (widget.rekap != null) {
      updateRekapView(widget.rekap!);
    }
    super.initState();

    getDailyAverage(totalExpense, totalIncome);

    _tabController = TabController(length: 3, vsync: this);

    updateR(0);
    updateN(0);
    _loadData();

    getRekapType(dbStartDate, dbEndDate).then((dataMap) {
      setState(() {
        _pieChartIncExp = dataMap;
      });
    });

    getAllTransactions(dbStartDate, dbEndDate).then((dataMap) {
      setState(() {
        _allTransactionPieChart = dataMap;
      });
    });

    // Inc Name Piechart
    getIncNamePieChart(dbStartDate, dbEndDate).then((dataMap) {
      setState(() {
        _pieChartIncName = dataMap;
      });
    });

    // Exp Name Piechart
    getExpNamePieChart(dbStartDate, dbEndDate).then((dataMap) {
      setState(() {
        _pieChartExpName = dataMap;
      });
    });
  }

  Stream<List<Rekap>> getCustomRekaps() {
    return database.getCustomRekaps();
  }

  Stream<List<Rekap>> getMonthlyRekaps() {
    return database.getMonthlyRekaps();
  }

  Future<List<Rekap>> getSingleRekap(id) {
    return database.getSingleRekaps(id);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future update(int id, DateTime startDate, DateTime endDate) async {
    return await database.updateRekapAmount(id, startDate, endDate);
  }

  final rekap_detail = Rekap;

  // Export Rekap To Excel
  void exportToExcel() async {
    final xlsio.Workbook workbook = new xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByName('A1').setText((lang == 0) ? 'Periode' : 'Period');
    sheet
        .getRangeByName('A2')
        .setText((lang == 0) ? 'Total Pemasukan' : 'Total Income');
    sheet
        .getRangeByName('A3')
        .setText((lang == 0) ? 'Total Pengeluaran' : 'Total Expense');
    sheet
        .getRangeByName('A4')
        .setText((lang == 0) ? 'Rata-rata Harian' : 'Daily Average');
    sheet.getRangeByName('A5').setText((lang == 0) ? 'Sisa' : 'Balance');

    // Styling dikit :v

    sheet.getRangeByName('A1').cellStyle.backColor = '#00eeee';
    sheet.getRangeByName('A2').cellStyle.backColor = '#03c03c';
    sheet.getRangeByName('A3').cellStyle.backColor = '#FF0000';
    sheet.getRangeByName('A4').cellStyle.backColor = '#00eeee';
    sheet.getRangeByName('A5').cellStyle.backColor = '#00eeee';

    // Isi Dari Database & Menformatnya
    final periode = DateFormat('dd-MMMM-yyyy', (lang == 0) ? 'id_ID' : null)
            .format(dbStartDate)
            .toString() +
        " ~ " +
        DateFormat('dd-MMMM-yyyy', 'id_ID').format(dbEndDate).toString();

    var totIncome = "Rp." +
        (NumberFormat.currency(
          locale: 'id',
          decimalDigits: 0,
        ).format(
          totalIncome,
        )).replaceAll('IDR', '');
    var totExpense = "Rp." +
        (NumberFormat.currency(
          locale: 'id',
          decimalDigits: 0,
        ).format(
          totalExpense,
        )).replaceAll('IDR', '');
    var dailyAverages = "Rp." +
        (NumberFormat.currency(
          locale: 'id',
          decimalDigits: 0,
        ).format(dailyAverage))
            .replaceAll('IDR', '');
    var totSisa = "Rp." +
        (NumberFormat.currency(
          locale: 'id',
          decimalDigits: 0,
        ).format(balance))
            .replaceAll('IDR', '');

    sheet.getRangeByName('B1').setText(periode);
    sheet.getRangeByName('B2').setText(totIncome);
    sheet.getRangeByName('B3').setText(totExpense);
    sheet.getRangeByName('B4').setText(dailyAverages);
    sheet.getRangeByName('B5').setText(totSisa);

    // Berdasarkan Kategori Pemasukan
    sheet.getRangeByName('B7:C7').merge(); //Nanti Dimerge
    sheet.getRangeByName('B7:C7').setText((lang == 0)
        ? "Berdasarkan Kategori Pemasukan"
        : "By Income Category"); //Nanti Dimerge
    sheet.getRangeByName('B7:C7').cellStyle.backColor =
        '#03c03c'; //Nanti Dimerge
    sheet.getRangeByName('B8').setText((lang == 0) ? "Nama" : 'Name');
    sheet.getRangeByName('C8').setText((lang == 0) ? "Jumlah" : 'Amount');

    // ========================>Mapping Data Nama Kategori Pemasukan & Amount <==========================
    // Inc Name
    final int rowIncName = 9; // Represent the starting row.
    final int columnIncName = 2; // Represent the starting column.
    final bool incNameVertical =
        true; //  Represents that the data should be imported vertically.

    // Inc Name Amount
    final int rowAmountInc = 9; // Represent the starting row.
    final int columnAmountInc = 3; // Represent the starting column.
    final bool incAmountVertical = true;

    // Memasukkan data nama categori Income ke List
    List incName = [];
    List incAmount = [];
    int length_income = incomeCategory.length + rowIncName;
    incomeCategory.forEach((inc) => {
          print(inc["name"]),
          incName.add(inc["name"]),
          incAmount.add("Rp." +
              (NumberFormat.currency(
                locale: 'id',
                decimalDigits: 0,
              ).format(inc["totalAmount"]))
                  .replaceAll('IDR', ''))
        });
    print("isi Inc name $incName");
    print("isi Inc total Amount $incAmount");

    //Import the Name to Sheet
    sheet.importList(incName, rowIncName, columnIncName, incNameVertical);
    sheet.autoFitColumn(2);

    //Import the Amount list to Sheet
    sheet.importList(
        incAmount, rowAmountInc, columnAmountInc, incAmountVertical);
    sheet.autoFitColumn(3);

    // ========================>Mapping Data Nama Kategori Pengeluaran & Amount <==========================
    // Name
    final int rowExpName = length_income + 3; // Represent the starting row.
    final int columnExpName = 2; // Represent the starting column.
    final bool expNameVertical =
        true; //  Represents that the data should be imported vertically.

    // Amount
    final int rowAmountExp = length_income + 3; // Represent the starting row.
    final int columnAmountExp = 3; // Represent the starting column.
    final bool expAmountVertical = true;

    // Memasukkan data nama categori Income ke List
    List expName = [];
    List expAmount = [];

    expenseCategory.forEach((exp) => {
          print(exp["name"]),
          expName.add(exp["name"]),
          expAmount.add("Rp." +
              (NumberFormat.currency(
                locale: 'id',
                decimalDigits: 0,
              ).format(exp["totalAmount"]))
                  .replaceAll('IDR', ''))
        });
    print("isi Exp name $expName");
    print("isi Exp total Amount $expAmount");

    // Berdasarkan Kategori Pengeluaran
    String col = (rowExpName - 2).toString();
    String col2 = (rowExpName - 1).toString();
    sheet.getRangeByName('B$col:C$col').merge(); //Nanti Dimerge
    sheet.getRangeByName('B$col:C$col').setText((lang == 0)
        ? "Berdasarkan Kategori Pengeluaran"
        : 'By Expense Category '); //Nanti Dimerge

    // Styling Dikit :v
    sheet.getRangeByName('B$col:C$col').cellStyle.backColor =
        '#FF0000'; //Nanti Dimerge
    sheet.getRangeByName('B$col:C$col').cellStyle.hAlign =
        xlsio.HAlignType.center; //Nanti Dimerge

    sheet.getRangeByName('B$col2').setText((lang == 0) ? "Nama" : 'name');
    sheet.getRangeByName('C$col2').setText((lang == 0) ? "Jumlah" : 'Amount');

    //Import the Name to Sheet
    sheet.importList(expName, rowExpName, columnExpName, expNameVertical);
    sheet.autoFitColumn(2);

    //Import the Amount to Sheet
    sheet.importList(
        expAmount, rowAmountExp, columnAmountExp, expAmountVertical);
    sheet.autoFitColumn(3);

    //========================>Mapping Data All Transaksi <==========================
    //Daftar Transaksi
    sheet.getRangeByName('D1:I1').merge(); //Nanti Dimerge
    sheet
        .getRangeByName('D1:I1')
        .setText((lang == 0) ? "Daftar Transaksi" : 'Transactions List');
    sheet.getRangeByName('D1:I1').cellStyle.hAlign = xlsio.HAlignType.center;
    sheet.getRangeByName('D1:I1').cellStyle.backColor = '#00eeee';
    sheet.getRangeByName('D2').setText("No");
    sheet
        .getRangeByName('E2')
        .setText((lang == 0) ? 'Nama Transaksi' : 'Transaction Name');
    sheet.getRangeByName('F2').setText((lang == 0) ? 'Tanggal' : 'Date');
    sheet.getRangeByName('G2').setText((lang == 0) ? 'Jumlah' : 'Amount');
    sheet.getRangeByName('H2').setText((lang == 0) ? 'Tipe' : 'Type');
    sheet.getRangeByName('I2').setText((lang == 0) ? 'Kategori' : 'Category');

    // Mapping Data Transaksi

    // No
    final int rowNo = 3; // Represent the starting row.
    final int columnNo = 4; // Represent the starting column.
    final bool isNoVertical =
        true; //  Represents that the data should be imported vertically.

    // Name
    final int rowName = 3; // Represent the starting row.
    final int columnName = 5; // Represent the starting column.
    final bool isNameVertical =
        true; //  Represents that the data should be imported vertically.

    // Date
    final int rowDate = 3; // Represent the starting row.
    final int columnDate = 6; // Represent the starting column.
    final bool isDateVertical = true;

    // Amount
    final int rowAmount = 3; // Represent the starting row.
    final int columnAmount = 7; // Represent the starting column.
    final bool isAmountVertical = true;

    // Tipe
    final int rowType = 3; // Represent the starting row.
    final int columnType = 8; // Represent the starting column.
    final bool isTypeVertical = true;

    // Categori
    final int rowCategory = 3; // Represent the starting row.
    final int columnCategory = 9; // Represent the starting column.
    final bool isCategoryVertical = true;

    List no = [];
    List names = [];
    List date = [];
    List amount = [];
    List type = [];
    List category = [];

    // Ngedapatin Nomor
    int length = rekapTransactions.length;
    for (int i = 0; i < length; i++) {
      no.add(i + 1);
    }

    // Mapping data rekap transactions yg memiliki insance class dari TransactionWithCategory
    for (TransactionWithCategory tr in rekapTransactions) {
      // Masukkan data ke dalam map

      names.add(tr.transaction.name);

      //Format Tanggal & Jumlah
      var dateTr = DateFormat('dd-MMMM-yyyy', (lang == 0) ? 'id_ID' : null)
          .format(tr.transaction.transaction_date)
          .toString();
      var amounts = "Rp." +
          (NumberFormat.currency(
            locale: 'id',
            decimalDigits: 0,
          ).format(tr.transaction.amount))
              .replaceAll('IDR', '')
              .toString();

      date.add(dateTr);
      amount.add(amounts);
      category.add(tr.category.name);

      // Logic Khusus Untuk Type
      if (tr.category.type == 1) {
        type.add(lang == 0 ? "Pemasukan" : "Income");
      } else if (tr.category.type == 2) {
        type.add(lang == 0 ? "Pengeluaran" : "Expense");
      }
    }

    //Import the Index No to Sheet
    sheet.importList(no, rowNo, columnNo, isNoVertical);
    sheet.autoFitColumn(4);

    //Import the Name to Sheet
    sheet.importList(names, rowName, columnName, isNameVertical);
    sheet.autoFitColumn(5);

    //Import the Date to Sheet
    sheet.importList(date, rowDate, columnDate, isDateVertical);
    sheet.autoFitColumn(6);

    //Import the Amount to Sheet
    sheet.importList(amount, rowAmount, columnAmount, isAmountVertical);
    sheet.autoFitColumn(7);

    //Import the Type to Sheet
    sheet.importList(type, rowType, columnType, isTypeVertical);
    sheet.autoFitColumn(8);

    //Import the Category to Sheet
    sheet.importList(category, rowCategory, columnCategory, isCategoryVertical);
    sheet.autoFitColumn(9);

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/$name.xlsx';
    final File file = new File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    filePath = fileName;
  }

  void openExported() {
    OpenFile.open(filePath);
  }

  void updateN(int index) {
    setState(() {
      n = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          (lang == 0) ? "Detail Rekap" : "Report Details",
          style: GoogleFonts.inder(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: base,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: base),
        ),
        actions: [
          TextButton(
            onPressed: () {
              exportToExcel();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (lang == 0)
                            ? 'Berhasil Export Rekap'
                            : 'Export Report Success',
                        style: GoogleFonts.inder(color: base),
                      ),
                      TextButton(
                          onPressed: openExported,
                          child: Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            Text("Open",style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400,
                            ),),
                            SizedBox(width: 4),
                            Icon(Icons.file_open, size: 23 , color: base)
                          ]))
                    ],
                  ),
                  backgroundColor: primary,
                ),
              );
            },
            child: (r == 2 || r == 3)
                ? Text(
                    "Export",
                    style: GoogleFonts.inder(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: base,
                    ),
                  )
                : SizedBox.shrink(),
          ).animate().fade().slide(duration: 400.ms).then().shake(duration: 7000.ms),
        ],
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
          child: Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  color: (isDark) ? background : base,
                ),
                labelColor: (isDark) ? base : Colors.black87,
                unselectedLabelColor: Colors.white,
                tabs: _tabs,
                onTap: updateR,
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
                  color: (isDark) ? background : Colors.white,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              // Kalo Chart
                              if (r == 1) ...[
                                // By Type
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 20, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      DropdownButton<String>(
                                        dropdownColor:
                                            isDark ? card : Colors.white,
                                        value: dropDown,
                                        elevation: 16,
                                        underline: Container(
                                          height: 2,
                                          color: isDark ? Colors.white : home,
                                        ),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            overflow: TextOverflow.ellipsis,
                                            color:
                                                isDark ? base : Colors.black),
                                        onChanged: (String? value) {
                                          // This is called when the user selects an item.
                                          setState(() {
                                            dropDown = value!;
                                            int index = _list.indexOf(value);

                                            updateN(index);
                                          });
                                        },
                                        items: _list
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
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
                                  FutureBuilder<Map<String, double>>(
                                    future:
                                        getRekapType(dbStartDate, dbEndDate),
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
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 35),
                                                  child: PieChart(
                                                    dataMap: _pieChartIncExp,
                                                    colorList: [
                                                      Colors.greenAccent,
                                                      Colors.redAccent
                                                    ],
                                                    chartRadius:
                                                        MediaQuery.of(context)
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
                                                          LegendPosition.bottom,
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
                                            return Center();
                                          }
                                        } else {
                                          return Center();
                                        }
                                      }
                                    },
                                  ),
                                ],

                                if (n == 1) ...[
                                  // ===================================>All Transaction Inc Name Map<===================================
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.only(top: 45),
                                  //   child: Text(
                                  //     (lang == 0)
                                  //         ? "Berdasarkan Kategori Pemasukan"
                                  //         : "By Income Category ",
                                  //     style: GoogleFonts.inder(
                                  //       fontSize: 17,
                                  //       color:
                                  //           isDark ? base : Colors.black,
                                  //     ),
                                  //   ),
                                  // ),

                                  FutureBuilder<Map<String, double>>(
                                    future: getIncNamePieChart(
                                        dbStartDate, dbEndDate),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center();
                                      } else {
                                        if (snapshot.hasData) {
                                          if (snapshot.data!.length > 0) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 35),
                                                  child: PieChart(
                                                    dataMap: _pieChartIncName,
                                                    chartRadius:
                                                        MediaQuery.of(context)
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
                                                          LegendPosition.bottom,
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
                                                        ? "Belum ada transaksi"
                                                        : "No transactions yet",
                                                    style: GoogleFonts.inder(
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
                                            padding: const EdgeInsets.only(
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
                                  ),
                                ],
                                // ===================================>All Transaction Expense Name Map<===================================
                                if (n == 2) ...[
                                  FutureBuilder<Map<String, double>>(
                                    future: getExpNamePieChart(
                                        dbStartDate, dbEndDate),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center();
                                      } else {
                                        if (snapshot.hasData) {
                                          if (snapshot.data!.length > 0) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 35),
                                                  child: PieChart(
                                                    dataMap: _pieChartExpName,
                                                    chartRadius:
                                                        MediaQuery.of(context)
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
                                                          LegendPosition.bottom,
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
                                                        ? "Belum ada transaksi"
                                                        : "No transactions yet",
                                                    style: GoogleFonts.inder(
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
                                            padding: const EdgeInsets.only(
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
                                  ),
                                ],

                                if (n == 3) ...[
                                  // ===================================>All Transaction Data Map<===================================
                                  FutureBuilder<Map<String, double>>(
                                    future: getAllTransactions(
                                        dbStartDate, dbEndDate),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center();
                                      } else {
                                        if (snapshot.hasData) {
                                          if (snapshot.data!.length > 0) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 35, bottom: 60),
                                                  child: PieChart(
                                                    dataMap:
                                                        _allTransactionPieChart,
                                                    chartRadius:
                                                        MediaQuery.of(context)
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
                                                          LegendPosition.bottom,
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
                                                        ? "Belum ada transaksi"
                                                        : "No transactions yet",
                                                    style: GoogleFonts.inder(
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
                                            padding: const EdgeInsets.only(
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
                                  ),
                                ],
                              ]
                              // Kalo Kategori
                              else if (r == 2) ...[
                                Expanded(
                                    child: Column(
                                  children: [
                                    // Details
                                    Details(
                                      name: name,
                                      startDate: dbStartDate,
                                      endDate: dbEndDate,
                                      totalExpense: totalExpense,
                                      totalIncome: totalIncome,
                                      dailyAverage: dailyAverage,
                                      balance: balance,
                                      isMonthly: isMonthly,
                                    ),

                                    // ---------------------------> Mapping data Expense <---------------------------------------
                                    Text(
                                      (lang == 0)
                                          ? "Pengeluaran Berdasarkan Kategori"
                                          : "Expense by Category",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? base : Colors.black),
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: FutureBuilder<
                                              List<Map<String, Object>?>>(
                                          future: database.getCatNameByRekaps(
                                              dbStartDate, dbEndDate, 2),
                                          builder: (context, snapshot) {
                                            expenseCategory = snapshot.data;
                                            print(
                                                "isi  category $expenseCategory");
                                            // final expenseCategory =
                                            //     snapshot.data![1];

                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(primary));
                                            } else {
                                              if (snapshot.hasData) {
                                                if (snapshot.data!.length > 0) {
                                                  return ListView.builder(
                                                      itemCount:
                                                          snapshot.data!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var expenseNames =
                                                            snapshot.data![
                                                                index]!["name"];
                                                        var expenseAmount =
                                                            snapshot.data![
                                                                    index]![
                                                                "totalAmount"];
                                                        print(
                                                            "xpense $expenseNames");
                                                        print(
                                                            "amount $expenseAmount");

                                                        // Convert to Rp
                                                        var amountString =
                                                            (NumberFormat
                                                                    .currency(
                                                          locale: 'id',
                                                          decimalDigits: 0,
                                                        ).format(expenseAmount))
                                                                .replaceAll(
                                                                    'IDR', '');

                                                        // Kalo Pengeluaran
                                                        return SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                  height: 20),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    expenseNames
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: isDark
                                                                        
                                                                            ? base
                                                                            : home),
                                                                  ), // Nama kategori income
                                                                  Text(
                                                                    "Rp." +
                                                                        amountString,
                                                                    style: TextStyle(
                                                                        color: isDark
                                                                            ? base
                                                                            : home),
                                                                  ), // Total Expense
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 7),
                                                              LinearPercentIndicator(
                                                                animation: true,
                                                                animationDuration: 500,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.87,
                                                                barRadius:
                                                                    const Radius
                                                                        .circular(
                                                                        16),
                                                                lineHeight: 8.0,
                                                                percent:
                                                                    calculatePercentage(
                                                                  (expenseAmount
                                                                          as num)
                                                                      .toDouble(),
                                                                  totalExpense
                                                                      .toDouble(),
                                                                ), // Ganti nilai persentase sesuai kebutuhan
                                                                progressColor:
                                                                    Colors.red,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                }
                                              }
                                              return Text(
                                                (lang == 0)
                                                    ? "Belum ada pengeluaran"
                                                    : "No expenses yet",
                                                style: TextStyle(
                                                    color:
                                                        isDark ? base : home),
                                              );
                                            }
                                          }),
                                    ),

                                    SizedBox(height: 5),
                                    Text(
                                      (lang == 0)
                                          ? "Pemasukan Berdasarkan Kategori"
                                          : "Income by Category",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? base : Colors.black),
                                    ),
                                    SizedBox(height: 10),

                                    // ---------------------------> Mapping data Income <---------------------------------------
                                    Expanded(
                                      child: FutureBuilder<
                                              List<Map<String, Object>?>>(
                                          future: database.getCatNameByRekaps(
                                              dbStartDate, dbEndDate, 1),
                                          builder: (context, snapshot) {
                                            incomeCategory = snapshot.data;
                                            print(
                                                "tes isi  category $incomeCategory");
                                            // final expenseCategory =
                                            //     snapshot.data![1];

                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(primary));
                                            } else {
                                              if (snapshot.hasData) {
                                                if (snapshot.data!.length > 0) {
                                                  return ListView.builder(
                                                      itemCount:
                                                          snapshot.data!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var incomeNames =
                                                            snapshot.data![
                                                                index]!["name"];
                                                        var incomeAmount =
                                                            snapshot.data![
                                                                    index]![
                                                                "totalAmount"];

                                                        // Convert to Rp
                                                        var amountString =
                                                            (NumberFormat
                                                                    .currency(
                                                          locale: 'id',
                                                          decimalDigits: 0,
                                                        ).format(incomeAmount))
                                                                .replaceAll(
                                                                    'IDR', '');

                                                        // Kalo Pengeluaran
                                                        return SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                  height: 20),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    incomeNames
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: isDark
                                                                            ? base
                                                                            : home),
                                                                  ), // Nama kategori income
                                                                  Text(
                                                                    "Rp." +
                                                                        amountString,
                                                                    style: TextStyle(
                                                                        color: isDark
                                                                            ? base
                                                                            : home),
                                                                  ), // Total Income
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 7),
                                                              LinearPercentIndicator(
                                                                animation: true,
                                                                animationDuration: 500,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.87,
                                                                barRadius:
                                                                    const Radius
                                                                        .circular(
                                                                        16),
                                                                lineHeight: 8.0,
                                                                percent:
                                                                    calculatePercentage(
                                                                  (incomeAmount
                                                                          as num)
                                                                      .toDouble(),
                                                                  totalIncome
                                                                      .toDouble(),
                                                                ), // Ganti nilai persentase sesuai kebutuhan
                                                                progressColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                }
                                              }
                                              return Text(
                                                (lang == 0)
                                                    ? "Belum ada pemasukan"
                                                    : "No incomes yet",
                                                style: TextStyle(
                                                    color:
                                                        isDark ? base : home),
                                              );
                                            }
                                          }),
                                    ),

                                    SizedBox(height: 25),
                                  ],
                                ))

                                // Kalo Transaksi
                              ] else if (r == 3) ...[
                                Expanded(
                                  child: Column(
                                    children: [
                                      Details(
                                        name: name,
                                        startDate: dbStartDate,
                                        endDate: dbEndDate,
                                        totalExpense: totalExpense,
                                        totalIncome: totalIncome,
                                        dailyAverage: dailyAverage,
                                        balance: balance,
                                        isMonthly: isMonthly,
                                      ),

                                      // ---------------------------> Mapping Transaction Name <---------------------------------------
                                      Expanded(
                                        child: StreamBuilder<
                                            List<TransactionWithCategory>>(
                                          stream:
                                              database.getTransactionByRekaps(
                                                  dbStartDate, dbEndDate),
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
                                                if (snapshot.data!.length > 0) {
                                                  return ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          snapshot.data!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final type = snapshot
                                                            .data![index]
                                                            .category
                                                            .type;
                                                        rekapTransactions =
                                                            snapshot.data;
                                                        return ListTile(
                                                          leading: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: isDark
                                                                  ? card
                                                                  : base,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          35),
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
                                                                        .cover,
                                                                    width: 50,
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
                                                                        width:
                                                                            50,
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
                                                          subtitle: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        snapshot
                                                                            .data![index]
                                                                            .transaction
                                                                            .name,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: isDark
                                                                                ? base
                                                                                : home),
                                                                      ),
                                                                      Text(
                                                                        (lang ==
                                                                                0)
                                                                            ? DateFormat.yMMMMEEEEd('id_ID').format(
                                                                                DateTime.parse(snapshot.data![index].transaction.transaction_date.toString()),
                                                                              )
                                                                            : DateFormat.yMMMMEEEEd().format(DateTime.parse(snapshot.data![index].transaction.transaction_date.toString())),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color: isDark
                                                                                ? base
                                                                                : home),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                  ((snapshot.data![index].category.type == 1) ? '+' : '-') +  'Rp. ' +
                                                                        (NumberFormat
                                                                                .currency(
                                                                          locale:
                                                                              'id',
                                                                          decimalDigits:
                                                                              0,
                                                                        )
                                                                            .format(
                                                                          snapshot
                                                                              .data![index]
                                                                              .transaction
                                                                              .amount,
                                                                        )).replaceAll(
                                                                            'IDR',
                                                                            ''),
                                                                    style: TextStyle(

                                                                        color: (snapshot.data![index].category.type == 1) ? Colors.green : Color.fromARGB(255, 231, 44, 31)),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  LinearPercentIndicator(
                                                                    animation: true,
                                                                    animationDuration: 500,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.52,
                                                                    barRadius:
                                                                        const Radius
                                                                            .circular(
                                                                            16),
                                                                    lineHeight:
                                                                        7.0,
                                                                    percent:
                                                                        calculatePercentage(
                                                                      (snapshot
                                                                              .data![index]
                                                                              .transaction
                                                                              .amount)
                                                                          .toDouble(),
                                                                      (type ==
                                                                              1)
                                                                          ? totalIncome
                                                                              .toDouble()
                                                                          : totalExpense
                                                                              .toDouble(),
                                                                    ), // Ganti nilai persentase sesuai kebutuhan
                                                                    progressColor: (type ==
                                                                            1)
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .red,
                                                                  ),
                                                                  IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_forward_ios_sharp,
                                                                        color:
                                                                            primary,
                                                                        size:
                                                                            16,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .push(
                                                                          MaterialPageRoute(
                                                                            builder: ((context) =>
                                                                                TransactionPage(
                                                                                  transactionWithCategory: snapshot.data![index],
                                                                                )),
                                                                          ),
                                                                        );
                                                                      })
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                } else {
                                                  return Center(
                                                    child: Text(
                                                      (lang == 0)
                                                          ? 'Tidak ada data'
                                                          : "No data",
                                                      style: TextStyle(
                                                        color: isDark
                                                            ? base
                                                            : home,
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
                                                      color:
                                                          isDark ? base : home,
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 35),
                                          child: SizedBox.shrink())
                                      // SizedBox.shrink()
                                    ],
                                  ),
                                ),
                              ],
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
      ),
      floatingActionButton: (r == 1 || r == 3)
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
                    builder: (context) => GalleryRekapPage(
                        startDate: dbStartDate, endDate: dbEndDate),
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
      bottomNavigationBar: BottomAppBar(
        color: isDark ? dialog : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            HomePage(selectedDate: DateTime.now()),
                      ),
                      (route) => false);
                },
                icon: Icon(
                  Icons.home,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            // SizedBox(
            //   width: 20,
            // ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(),
                      ),
                      (route) => false);
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
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => RekapPage(
                        r: 1,
                      ),
                    ),
                    (route) => false,
                  );
                },
                icon: Icon(
                  Icons.bar_chart,
                  color: primary,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    ),
                    (route) => false,
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
