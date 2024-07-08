//add+edit
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tangan/pages/category_page.dart';
import 'package:tangan/pages/home_page.dart';
// import 'package:sisaku/colors.dart';
import 'setting_page.dart';

import 'package:tangan/pages/rekap_page.dart';

import 'package:tangan/models/database.dart';

class AddEditRekap extends StatefulWidget {
  final Rekap? rekap;
  const AddEditRekap({super.key, required this.rekap});

  @override
  State<AddEditRekap> createState() => _AddEditRekapState();
}

class _AddEditRekapState extends State<AddEditRekap> {
  late int type;
  final AppDb database = AppDb();

  // Form Controller
  TextEditingController namaRekapController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  // Variabel
  String dbStartDate = '';
  String dbEndDate = '';

  void updateRekapView(Rekap rekap) {
    namaRekapController.text = rekap.name.toString();
    startDateController.text =
        DateFormat('dd-MMMM-yyyy').format(rekap.startDate);
    dbStartDate = DateFormat('yyyy-MM-dd').format(rekap.startDate);
    endDateController.text = DateFormat('dd-MMMM-yyyy').format(rekap.endDate);
    dbEndDate = DateFormat('yyyy-MM-dd').format(rekap.endDate);
  }

//Future Function CRUD
  Future insert(String namaRekap, DateTime startDate, DateTime endDate) async {
    return await database.insertRekap(namaRekap, startDate, endDate);
  }

  Future update(
      int id, String namaRekap, DateTime startDate, DateTime endDate) async {
    return await database.updateRekap(id, namaRekap, startDate, endDate);
  }

  @override
  void initState() {
    if (widget.rekap != null) {
      updateRekapView(widget.rekap!);
    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          (widget.rekap == null)
              ? (lang == 0)
                  ? "Tambah Rekap"
                  : "Add Report"
              : (lang == 0)
                  ? "Edit Rekap"
                  : "Edit Report",
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: TextFormField(
                    style: TextStyle(color: isDark ? base : home),
                    controller: namaRekapController,
                    cursorColor: primary,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return (lang == 0)
                            ? 'Nama Rekap tidak boleh kosong'
                            : 'Report Name cannot be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primary)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: isDark ? base : home),
                      ),
                      labelStyle:
                          TextStyle(color: isDark ? base : Colors.black),
                      labelText: (lang == 0) ? 'Nama Rekap' : 'Report Name',
                    ),
                  ),
                ),

                // =>Start Date
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    style: TextStyle(color: isDark ? base : home),
                    readOnly: true,
                    controller: startDateController,
                    cursorColor: primary,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return (lang == 0)
                            ? 'Tanggal Mulai tidak boleh kosong'
                            : "Start Date cannot be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primary)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: isDark ? base : home),
                      ),
                      labelStyle:
                          TextStyle(color: isDark ? base : Colors.black),
                      labelText: (lang == 0)
                          ? 'Pilih Tanggal Mulai'
                          : "Choose Start Date",
                      suffixIcon: Icon(
                        Icons.calendar_month_rounded,
                        color: primary,
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          locale: (lang == 0)
                              ? Locale('id', 'ID')
                              : Locale('en', 'EN'),
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                            colorScheme: isDark
                                              ? ColorScheme.dark(
                                                primary: primary,
                                                onPrimary: base,
                                                onSurface: base,
                                                )
                                              : ColorScheme.light(
                                                primary: primary,
                                                onPrimary: base,
                                                onSurface: Colors.black,
                                                ),
                                dialogBackgroundColor:
                                    isDark ? card : Colors.white,
                              ),
                              child: child!,
                            );
                          });

                      if (pickedDate != Null) {
                        String formattedDate = (lang == 0)
                            ? DateFormat('dd-MMMM-yyyy', 'id_ID')
                                .format(pickedDate!)
                            : DateFormat('dd-MMMM-yyyy').format(pickedDate!);
                        startDateController.text = formattedDate;
                        String data =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          dbStartDate = data;
                        });
                      }
                    },
                  ),
                ),

                // EndDate
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    style: TextStyle(color: isDark ? base : home),
                    readOnly: true,
                    controller: endDateController,
                    cursorColor: primary,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return (lang == 0)
                            ? 'Tanggal Berakhir tidak boleh kosong'
                            : 'End Date cannot be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primary)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: isDark ? base : home),
                      ),
                      labelStyle:
                          TextStyle(color: isDark ? base : Colors.black),
                      labelText: (lang == 0)
                          ? 'Pilih Tanggal Berakhir'
                          : "Choose End Date",
                      suffixIcon: Icon(
                        Icons.calendar_month_rounded,
                        color: primary,
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          locale: (lang == 0)
                              ? Locale('id', 'ID')
                              : Locale('en', 'EN'),
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                            colorScheme: isDark
                                              ? ColorScheme.dark(
                                                primary: primary,
                                                onPrimary: base,
                                                onSurface: base,
                                                )
                                              : ColorScheme.light(
                                                primary: primary,
                                                onPrimary: base,
                                                onSurface: Colors.black,
                                                ),
                                dialogBackgroundColor:
                                    isDark ? card : Colors.white,
                              ),
                              child: child!,
                            );
                          });

                      if (pickedDate != Null) {
                        String formattedDate = (lang == 0)
                            ? DateFormat('dd-MMMM-yyyy', 'id_ID')
                                .format(pickedDate!)
                            : DateFormat('dd-MMMM-yyyy').format(pickedDate!);
                        endDateController.text = formattedDate;
                        String data =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          dbEndDate = data;
                        });
                      }
                    },
                  ),
                ),

                // Button Save
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: () async {
                      // Memproses CRUD
                      if (_formKey.currentState!.validate()) {
                        if (widget.rekap == null) {
                          await insert(
                            namaRekapController.text,
                            DateTime.parse(dbStartDate),
                            DateTime.parse(dbEndDate),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                (lang == 0)
                                    ? 'Berhasil Tambah Rekap'
                                    : "Add Rekap Success",
                                style: GoogleFonts.inder(color: base),
                              ),
                              backgroundColor: primary,
                            ),
                          );
                        } else {
                          if (widget.rekap != null) {
                            await update(
                              widget.rekap!.id,
                              namaRekapController.text,
                              DateTime.parse(dbStartDate),
                              DateTime.parse(dbEndDate),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  (lang == 0)
                                      ? 'Berhasil Edit Rekap'
                                      : "Edit Report Success",
                                  style: GoogleFonts.inder(color: base),
                                ),
                                backgroundColor: primary,
                              ),
                            );
                          }
                        }

                        final route = MaterialPageRoute(
                          builder: (context) => RekapPage(
                            r: 3,
                          ),
                        );
                        Navigator.of(context)
                            .pushAndRemoveUntil(route, (route) => false);
                      }
                    },
                    child: Text(
                      (lang == 0) ? "Simpan" : "Save",
                      style: GoogleFonts.inder(
                        color: base,
                        fontSize: 15,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          // (isExpense) ? MaterialStateProperty.all<Color>(Colors.red) :
                          MaterialStateProperty.all<Color>(primary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: isDark ? background : Colors.white,
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
