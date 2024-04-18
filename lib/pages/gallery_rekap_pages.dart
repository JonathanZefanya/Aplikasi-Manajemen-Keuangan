import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tangan/models/database.dart';

// import 'package:sisaku/colors.dart';
import 'package:tangan/models/transaction_with_category.dart';
import 'package:tangan/pages/category_page.dart';
import 'package:tangan/pages/home_page.dart';
import 'package:tangan/pages/rekap_page.dart';
import 'package:tangan/pages/setting_page.dart';
import 'package:tangan/widgets/switch_button.dart';

class GalleryRekapPage extends StatefulWidget {
  const GalleryRekapPage(
      {super.key, required this.startDate, required this.endDate});
  final startDate;
  final endDate;
  @override
  State<GalleryRekapPage> createState() => _GalleryRekapPageState();
}

class _GalleryRekapPageState extends State<GalleryRekapPage> {
  late int type;
  final AppDb database = AppDb();

  void initState() {
    updateType(1);
    super.initState();
  }

  void updateType(int index) {
    setState(() {
      type = index;
    });
    print("tipe sekarang : " + type.toString());
  }

  Stream<List<TransactionWithCategory>> getGallery() {
    return database.getGalleryRekap(widget.startDate, widget.endDate, type);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (lang == 0) ? "Galeri" : "Gallery",
                  style: GoogleFonts.inder(
                    fontSize: 23,
                    color: base,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SwitchButton(type: type, updateType: updateType)
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? background : base,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<List<TransactionWithCategory>>(
                          stream: database.getGalleryRekap(
                              widget.startDate, widget.endDate, type),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(primary)),
                              );
                            } else {
                              if (snapshot.hasData) {
                                if (snapshot.data!.length > 0) {
                                  return ListView.builder(
                                    itemCount: 1,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SingleChildScrollView(
                                          child: SafeArea(
                                            child: Container(
                                              width: double.infinity,
                                              margin: EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Wrap(
                                                    spacing: 15,
                                                    runSpacing: 15,
                                                    children: snapshot.data!
                                                        .map((e) => Stack(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) =>
                                                                              AlertDialog(
                                                                        content:
                                                                            Stack(
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          children: [
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width / 1,
                                                                              height: MediaQuery.of(context).size.height / 2,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                image: DecorationImage(
                                                                                  fit: BoxFit.fill,
                                                                                  image: MemoryImage(e.transaction.image ?? Uint8List(0)),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  color: Color.fromRGBO(
                                                                                    0,
                                                                                    0,
                                                                                    0,
                                                                                    0.7,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.only(
                                                                                    bottomLeft: Radius.circular(10),
                                                                                    bottomRight: Radius.circular(10),
                                                                                  ),
                                                                                ),
                                                                                width: MediaQuery.of(context).size.width / 1,
                                                                                height: MediaQuery.of(context).size.height / 6,
                                                                                alignment: Alignment.center,
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      e.transaction.name,
                                                                                      style: GoogleFonts.inder(
                                                                                        fontSize: 24,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: base,
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      " (" + e.category.name + ")",
                                                                                      style: GoogleFonts.inder(
                                                                                        fontSize: 20,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: (e.category.type == 1) ? Colors.green : Colors.redAccent,
                                                                                      ),
                                                                                    ),
                                                                                    Divider(
                                                                                      thickness: 3,
                                                                                      color: primary,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                      children: [
                                                                                        Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              (lang == 0) ? "Tanggal Transaksi" : "Transaction Date",
                                                                                              style: GoogleFonts.inder(
                                                                                                fontSize: 14,
                                                                                                color: base,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              DateFormat('dd-MMMM-yyyy').format(e.transaction.transaction_date),
                                                                                              style: GoogleFonts.inder(
                                                                                                fontSize: 14,
                                                                                                color: base,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 20,
                                                                                          child: Container(
                                                                                            decoration: BoxDecoration(border: Border.all(color: base)),
                                                                                          ),
                                                                                        ),
                                                                                        Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                                          children: [
                                                                                            Text(
                                                                                              (lang == 0) ? 'Jumlah Uang' : "Amount",
                                                                                              style: GoogleFonts.inder(
                                                                                                fontSize: 14,
                                                                                                color: base,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              'Rp. ' +
                                                                                                  (NumberFormat.currency(
                                                                                                    locale: 'id',
                                                                                                    decimalDigits: 0,
                                                                                                  ).format(
                                                                                                    e.transaction.amount,
                                                                                                  )).replaceAll('IDR', ''),
                                                                                              style: GoogleFonts.inder(
                                                                                                fontSize: 14,
                                                                                                color: base,
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
                                                                          ],
                                                                        ),
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        scrollable:
                                                                            true,
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2.5,
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height /
                                                                        4.2,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      image:
                                                                          DecorationImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        // fit: BoxFit.cover,// OR BoxFit.fitWidth
                                                                        // alignment: FractionalOffset.topCenter,
                                                                        image: MemoryImage(e.transaction.image ??
                                                                            Uint8List(0)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0.7),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        bottomLeft:
                                                                            Radius.circular(10),
                                                                        bottomRight:
                                                                            Radius.circular(10),
                                                                      ),
                                                                    ),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2.5,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                          e.transaction
                                                                              .name,
                                                                          style:
                                                                              GoogleFonts.inder(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          " (" +
                                                                              e.category.name +
                                                                              ")",
                                                                          style:
                                                                              GoogleFonts.inder(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: (e.category.type == 1)
                                                                                ? Colors.green
                                                                                : Colors.redAccent,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ).animate().fadeIn().then().slide().then().shakeY(duration: 270.ms, amount: 2 )
                                                            )
                                                        .toList()
                                                        .toSet()
                                                        .toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 85),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 35),
                                        Image.asset(
                                          'assets/img/tes.png',
                                          width: 200,
                                        ),
                                        Text(
                                          (lang == 0)
                                              ? "Belum ada transaksi dengan gambar"
                                              : "No transactions with image yet",
                                          style: GoogleFonts.inder(
                                              color:
                                                  isDark ? base : Colors.black),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 85),
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
                                                isDark ? base : Colors.black),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
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
                  color: isDark ? Colors.white : Colors.black,
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