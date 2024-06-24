import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sisaku/colors.dart';
import 'package:tangan/models/database.dart';
import 'package:tangan/pages/about.dart';
import 'package:tangan/pages/category_page.dart';
import 'package:tangan/pages/home_page.dart';
import 'package:tangan/pages/rekap_page.dart';
import 'package:tangan/pages/exchange_page.dart';
import 'package:tangan/pages/rekap_dollar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final AppDb database = AppDb();

  @override
  void initState() {
    super.initState();

    loadData();
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
              (lang == 0) ? "Pengaturan" : 'Setting',
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
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(45),
                        child: Column(
                          children: [
                            // // Remove Ads
                            // Row(children: [
                            //   Container(
                            //       decoration: BoxDecoration(
                            //           color: primary,
                            //           borderRadius: BorderRadius.circular(3)),
                            //       child: Icon(
                            //         Icons.price_check_rounded,
                            //         color: base,
                            //         size: 27,
                            //       )),
                            //   SizedBox(width: 20),
                            //   TextButton(
                            //       child: Text(
                            //         (lang == 0) ? "Hapus Iklan" : 'Remove Ads',
                            //         style: TextStyle(
                            //             color: isDark ? base : Colors.black),
                            //       ),
                            //       style: TextButton.styleFrom(
                            //           foregroundColor: Colors.black),
                            //       onPressed: () {}),
                            // ]),
                            // SizedBox(height: 18),

                            // // Backup and Restore Data
                            // Row(children: [
                            //   Container(
                            //       decoration: BoxDecoration(
                            //           color: primary,
                            //           borderRadius: BorderRadius.circular(3)),
                            //       child: Icon(
                            //         Icons.restore_page,
                            //         color: base,
                            //         size: 27,
                            //       )),
                            //   SizedBox(width: 20),
                            //   TextButton(
                            //       child: Text(
                            //         "Backup dan Restore Data",
                            //         style: TextStyle(
                            //             color: isDark ? base : Colors.black),
                            //       ),
                            //       style: TextButton.styleFrom(
                            //           foregroundColor: Colors.black),
                            //       onPressed: () {}),
                            // ]),
                            // SizedBox(height: 18),
                            Row(children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(3)),
                                child: Icon(
                                  Icons.delete_rounded,
                                  color: base,
                                  size: 27,
                                ),
                              ),
                              SizedBox(width: 20),
                              TextButton(
                                  child: Text(
                                    (lang == 0)
                                        ? "Hapus Semua Data"
                                        : 'Clear All Data',
                                    style: TextStyle(
                                        color: isDark ? base : Colors.black),
                                  ),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                isDark ? dialog : Colors.white,
                                            shadowColor: Colors.red[50],
                                            content: SingleChildScrollView(
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        (lang == 0)
                                                            ? 'Yakin ingin Hapus?'
                                                            : 'Are you sure you want to clear all data?',
                                                        style:
                                                            GoogleFonts.inder(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isDark
                                                              ? base
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            (lang == 0)
                                                                ? 'Batal'
                                                                : 'Cancel',
                                                            style: GoogleFonts
                                                                .inder(
                                                              color: isDark
                                                                  ? base
                                                                  : home,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(
                                                                      primary)),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop('dialog');
                                                            database
                                                                .deleteAll();
                                                            setState(() {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                    content:
                                                                        Text(
                                                                      (lang ==
                                                                              0)
                                                                          ? 'Berhasil Hapus Semua Data'
                                                                          : 'Clear All Data Success',
                                                                      style: GoogleFonts.inder(
                                                                          color:
                                                                              base),
                                                                    ),
                                                                    backgroundColor:
                                                                        primary),
                                                              );
                                                            });
                                                          },
                                                          child: Text(
                                                            (lang == 0)
                                                                ? 'Ya'
                                                                : 'Yes',
                                                            style: GoogleFonts
                                                                .inder(
                                                              color: base,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                  }),
                            ]),
                            SizedBox(height: 18),
                            Row(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Icon(
                                    Icons.brush_rounded,
                                    color: base,
                                    size: 27,
                                  )),
                              SizedBox(width: 20),
                              TextButton(
                                  child: Text(
                                    (lang == 0) ? "Tema Warna" : "Theme",
                                    style: TextStyle(
                                        color: isDark ? base : Colors.black),
                                  ),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor:
                                              isDark ? dialog : Colors.white,
                                          title: Text(
                                            (lang == 0)
                                                ? "Pilih Warna"
                                                : "Choose Theme Color",
                                            style: TextStyle(
                                                color: isDark
                                                    ? base
                                                    : Colors.black),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [

                                              // Cyan (Default)
                                              RadioListTile.adaptive(
                                                tileColor: isDark ? base : home,
                                                fillColor:
                                                    MaterialStatePropertyAll(
                                                        defaultTheme[0]),
                                                value: 0,
                                                groupValue: _kode,
                                                onChanged: (newKode) {
                                                  setState(() {
                                                    _kode = newKode!;
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  });
                                                  saveData();
                                                },
                                                title: Text("Cyan",
                                                    style: GoogleFonts.inder()),
                                                activeColor: defaultTheme[0],
                                                selected: true,
                                              ),

                                              // Magenta
                                              RadioListTile.adaptive(
                                                tileColor: isDark ? base : home,
                                                fillColor:
                                                    MaterialStatePropertyAll(
                                                        defaultTheme[1]),
                                                value: 1,
                                                groupValue: _kode,
                                                onChanged: (newKode) {
                                                  setState(() {
                                                    _kode = newKode!;
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  });
                                                  saveData();
                                                },
                                                title: Text("Dark Magenta",
                                                    style: GoogleFonts.inder()),
                                                activeColor: defaultTheme[1],
                                                selected: true,
                                              ),

                                              // Green
                                              RadioListTile.adaptive(
                                                tileColor: isDark ? base : home,
                                                fillColor:
                                                    MaterialStatePropertyAll(
                                                        defaultTheme[2]),
                                                value: 2,
                                                groupValue: _kode,
                                                onChanged: (newKode) {
                                                  setState(() {
                                                    _kode = newKode!;
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  });
                                                  saveData();
                                                },
                                                title: Text("Green",
                                                    style: GoogleFonts.inder()),
                                                activeColor: defaultTheme[2],
                                                selected: true,
                                              ),

                                              // Dark Orange
                                              RadioListTile.adaptive(
                                                tileColor: isDark ? base : home,
                                                fillColor:
                                                    MaterialStatePropertyAll(
                                                        defaultTheme[3]),
                                                value: 3,
                                                groupValue: _kode,
                                                onChanged: (newKode) {
                                                  setState(() {
                                                    _kode = newKode!;
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  });
                                                  saveData();
                                                },
                                                title: Text("Dark Orange",
                                                    style: GoogleFonts.inder()),
                                                activeColor: defaultTheme[3],
                                                selected: true,
                                              ),

                                              // Dark Aqua Marine
                                            
                                              RadioListTile.adaptive(
                                                tileColor: isDark ? base : home,
                                                fillColor:
                                                    MaterialStatePropertyAll(
                                                        defaultTheme[4]),
                                                value: 4,
                                                groupValue: _kode,
                                                onChanged: (newKode) {
                                                  setState(() {
                                                    _kode = newKode!;
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  });
                                                  saveData();
                                                },
                                                title: Text("Aqua Marine",
                                                    style: GoogleFonts.inder()),
                                                activeColor: defaultTheme[4],
                                                selected: true,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }),
                            ]),
                            SizedBox(height: 18),
                            // Remider Notification
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: primary,
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          child: Icon(
                                            !isDark
                                                ? Icons.light_mode_rounded
                                                : Icons.dark_mode_rounded,
                                            color: base,
                                            size: 27,
                                          )),
                                      SizedBox(width: 20),
                                      TextButton(
                                          child: Text(
                                            "Dark Mode",
                                            style: TextStyle(
                                                color: isDark
                                                    ? base
                                                    : Colors.black),
                                          ),
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.black),
                                          onPressed: () {
                                            setState(() {
                                              (isDark)
                                                  ? isDark = false
                                                  : isDark = true;
                                              print(isDark);
                                            });
                                            saveData();
                                          }),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Switch(
                                        value: isDark,
                                        onChanged: (bool value) {
                                          setState(() {
                                            isDark = value;

                                            print(isDark);
                                          });
                                          saveData();
                                        },
                                        inactiveTrackColor: Colors.grey,
                                        activeColor: Colors.white,
                                        activeTrackColor: primary,
                                      ),
                                    ],
                                  ),
                                ]),
                            SizedBox(height: 18),
                            // Language
                            Row(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Icon(
                                    Icons.language,
                                    color: base,
                                    size: 27,
                                  )),
                              SizedBox(width: 20),
                              TextButton(
                                  child: Text(
                                    (lang == 0) ? "Bahasa" : "Language",
                                    style: TextStyle(
                                        color: isDark ? base : Colors.black),
                                  ),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor:
                                              isDark ? dialog : Colors.white,
                                          title: Text(
                                            (lang == 0)
                                                ? "Pilih Bahasa"
                                                : "Choose Language",
                                            style: TextStyle(
                                                color: isDark
                                                    ? base
                                                    : Colors.black),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              RadioListTile.adaptive(
                                                tileColor: isDark ? base : home,
                                                fillColor:
                                                    MaterialStatePropertyAll(
                                                        primary),
                                                value: 0,
                                                groupValue: lang,
                                                onChanged: (newLang) {
                                                  setState(() {
                                                    lang = newLang!;
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  });
                                                  saveData();
                                                },
                                                title: Text("Bahasa Indonesia",
                                                    style: GoogleFonts.inder()),
                                                activeColor: isDark
                                                    ? base
                                                    : Colors.black,
                                                selected: true,
                                              ),
                                              RadioListTile.adaptive(
                                                tileColor: isDark ? base : home,
                                                fillColor:
                                                    MaterialStatePropertyAll(
                                                        primary),
                                                value: 1,
                                                groupValue: lang,
                                                onChanged: (newLang) {
                                                  setState(() {
                                                    lang = newLang!;
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  });
                                                  saveData();
                                                },
                                                title: Text("English",
                                                    style: GoogleFonts.inder()),
                                                activeColor: isDark
                                                    ? base
                                                    : Colors.black,
                                                selected: true,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }),
                            ]),

                            // Convert Money
                            SizedBox(height: 18),
                            Row(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Icon(
                                    Icons.monetization_on,
                                    color: base,
                                    size: 27,
                                  )),
                              SizedBox(width: 20),
                              TextButton(
                                  child: Text(
                                    (lang == 0)
                                        ? "Konversi Mata Uang"
                                        : 'Currency Converter',
                                    style: TextStyle(
                                        color: isDark ? base : Colors.black),
                                  ),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ExchangePage(),
                                    ));
                                  }),
                            ]),

                            // Laporan Keuangan konversi ke ruang negeri
                            SizedBox(height: 18),
                            Row(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Icon(
                                    Icons.money,
                                    color: base,
                                    size: 27,
                                  )),
                              SizedBox(width: 20),
                              TextButton(
                                  child: Text(
                                    (lang == 0)
                                        ? "Laporan Keuangan"
                                        : 'Financial Report',
                                    style: TextStyle(
                                        color: isDark ? base : Colors.black),
                                  ),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => RekapDollar(
                                        r: 1,
                                      ),
                                    ));
                                  }),
                            ]),

                            // About Developer
                            SizedBox(height: 18),
                            Row(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Icon(
                                    Icons.code_outlined,
                                    color: base,
                                    size: 27,
                                  )),
                              SizedBox(width: 20),
                              TextButton(
                                  child: Text(
                                    (lang == 0)
                                        ? "Tentang Pengembang"
                                        : 'About Developer',
                                    style: TextStyle(
                                        color: isDark ? base : Colors.black),
                                  ),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => About(),
                                    ));
                                  }),
                            ]),
                            SizedBox(height: 32),

                            // Sosmed
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    (lang == 0) ? "Ikuti Kami" : "Follow Us",
                                    style: TextStyle(
                                        color: isDark ? base : Colors.black),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: primary,
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                        child: ImageIcon(
                                          AssetImage(
                                              "assets/img/mdi_instagram.png"),
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: primary,
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          child: Icon(
                                            Icons.facebook_sharp,
                                            color: base,
                                            size: 27,
                                          )),
                                      SizedBox(width: 20),
                                      Container(
                                        width: 40,
                                        height: 40,
                                        padding: EdgeInsets.all(9),
                                        decoration: BoxDecoration(
                                            color: primary,
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                        child: ImageIcon(
                                          AssetImage("assets/img/twitter.png"),
                                          color: Colors.white,
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
              ),
            ),
          ],
        ),
      ).animate().slideY(begin: 0.2, delay: 70.ms, duration: 400.ms),
      backgroundColor: primary,
      bottomNavigationBar: BottomAppBar(
        color: isDark ? dialog : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          HomePage(selectedDate: DateTime.now()),
                    ),
                  );
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
                onPressed: () {},
                icon: Icon(
                  Icons.settings,
                  color: primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

SharedPreferences? _sharedPreferences;

late int _kode = 0;
late bool isDark = false;
late int lang = 0;

// Fungsi untuk menyimpan data ke `SharedPreferences`
void saveData() async {
  // Buat objek `SharedPreferences`
  _sharedPreferences = await SharedPreferences.getInstance();
  // Simpan data ke `SharedPreferences`
  _sharedPreferences?.setInt("kode", _kode);
  _sharedPreferences?.setBool("isDark", isDark);
  _sharedPreferences?.setInt("lang", lang);
}

// Fungsi untuk mengambil data dari `SharedPreferences`
void loadData() async {
  // Buat objek `SharedPreferences`
  _sharedPreferences = await SharedPreferences.getInstance();
  // Ambil data dari `SharedPreferences`
  _kode = _sharedPreferences?.getInt("kode") ?? 0;
  isDark = _sharedPreferences?.getBool("isDark") ?? false;
  lang = _sharedPreferences?.getInt("lang") ?? 0;
}

Color get primary => _getPrimary(_kode);

Color _getPrimary(int kode) {
  return defaultTheme[kode];
}

const defaultTheme = [
  Color.fromARGB(255, 0, 171, 194),
  Color.fromARGB(255, 134, 27, 155),
  Color.fromARGB(255, 62, 166, 106),
  Color.fromARGB(209, 205, 117, 9),
  Color.fromARGB(187, 97, 207, 170)
];

const secondary = Color.fromARGB(255, 151, 221, 230);
const base = Color.fromARGB(255, 243, 243, 243);
const home = Color.fromARGB(162, 0, 35, 39);

const background = Color.fromARGB(255, 30, 39, 42);
const card = Color.fromRGBO(61, 61, 61, 1);
const dialog = Color.fromRGBO(33, 33, 33, 1);