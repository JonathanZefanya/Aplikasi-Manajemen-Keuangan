import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tangan/pages/category_page.dart';
import 'package:tangan/pages/home_page.dart';
import 'package:tangan/pages/rekap_page.dart';
import 'setting_page.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
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
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios_new_sharp, color: base),
                ),
                Text(
                  (lang == 0) ? "Tentang Pengembang" : 'About Developer',
                  style: GoogleFonts.inder(
                    fontSize: 23,
                    color: base,
                  ),
                ),
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
                decoration: BoxDecoration(
                  color: isDark ? background : base,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(children: [
                        SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Wrap(
                                  spacing: 20,
                                  runSpacing: 20,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/img/jojo.png'),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              thickness: 0.5,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Nama : '
                                                              : 'Name : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'NIM : '
                                                              : 'NIM : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Prodi : '
                                                              : 'Major : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Role : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Jonathan Natannael Zefanya',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? '1152200024'
                                                              : '1152200024',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Teknik Informatika'
                                                              : 'Informatics Engineering',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Programmer(Fullstack)',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).animate().fadeIn().then(delay:100.ms,).slideX().then().shakeY(duration: 270.ms, amount: 1 ),
                                    
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/img/rizky.jpg'),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              thickness: 0.5,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Nama : '
                                                              : 'Name : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'NIM : '
                                                              : 'NIM : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Prodi : '
                                                              : 'Major : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Role : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Rizky Aditya Syahputra',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? '1152200021'
                                                              : '1152200021',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Teknik Informatika'
                                                              : 'Informatics Engineering',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Programmer(Fullstack)',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).animate().fadeIn().then(delay:200.ms).slideX().then().shakeY( duration: 270.ms, amount: 1 ),

                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/img/dapanur.jpg'),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              thickness: 0.5,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Nama : '
                                                              : 'Name : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'NIM : '
                                                              : 'NIM : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Prodi : '
                                                              : 'Major : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Role : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Daffa Nur Fakhri',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? '1152200027'
                                                              : '1152200027',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Teknik Informatika'
                                                              : 'Informatics Engineering',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          'System Analyst',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).animate().fadeIn().then(delay:300.ms).slideX().then().shakeY( duration: 270.ms, amount: 1),

                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/img/dapadan.png'),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              thickness: 0.5,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Nama : '
                                                              : 'Name : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'NIM : '
                                                              : 'NIM : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Prodi : '
                                                              : 'Major : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Role : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Daffa Danindra',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? '1152200028'
                                                              : '1152200028',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Teknik Informatika'
                                                              : 'Informatics Engineering',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          lang == 0
                                                              ? 'Dokumenter'
                                                              : 'Dokumenter',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).animate().fadeIn().then(delay:400.ms).slideX().then().shakeY( duration: 270.ms, amount: 1),

                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: isDark ? card : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/img/arief.png'),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              thickness: 0.5,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Nama : '
                                                              : 'Name : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'NIM : '
                                                              : 'NIM : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Prodi : '
                                                              : 'Major : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Role : ',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Arief Fahroja',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? '1152605001'
                                                              : '1152605001',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          (lang == 0)
                                                              ? 'Teknik Informatika'
                                                              : 'Informatics Engineering',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Designer',
                                                          style:
                                                              GoogleFonts.inder(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).animate().fadeIn().then(delay:500.ms).slideX().then().shakeY( duration: 270.ms, amount: 1),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
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