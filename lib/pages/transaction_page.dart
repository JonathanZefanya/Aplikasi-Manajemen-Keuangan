import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tangan/pages/category_page.dart';
import 'package:tangan/pages/home_page.dart';
import 'package:tangan/pages/rekap_page.dart';
import 'package:tangan/pages/setting_page.dart';
import 'package:tangan/widgets/image_input.dart';

// import 'package:sisaku/colors.dart';
import 'dart:io';
import 'package:tangan/models/database.dart';
import 'package:tangan/models/transaction_with_category.dart';
import 'package:tangan/widgets/switch_button.dart';

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionWithCategory;

  const TransactionPage({
    super.key,
    required this.transactionWithCategory,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late int type;
  final AppDb database = AppDb();

  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  Category? selectedCategory;
  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  String dbDate = '';
  Uint8List? imageLama;

  @override
  void initState() {
    if (widget.transactionWithCategory != null) {
      updateTransactionView(widget.transactionWithCategory!);
    } else {
      updateType(1);
      type = type;
    }
    super.initState();
  }

  void updateType(int index) {
    setState(() {
      type = index;
      selectedCategory = null;
    });
    print("tipe sekarang : " + type.toString());
  }

  void updateTransactionView(TransactionWithCategory transactionWithCategory) {
    amountController.text =
        transactionWithCategory.transaction.amount.toString();
    deskripsiController.text = transactionWithCategory.transaction.name;
    dateController.text = DateFormat('dd-MMMM-yyyy')
        .format(transactionWithCategory.transaction.transaction_date);
    dbDate = DateFormat('yyyy-MM-dd')
        .format(transactionWithCategory.transaction.transaction_date);
    type = transactionWithCategory.category.type;
    selectedCategory = transactionWithCategory.category;
    imageLama = transactionWithCategory.transaction.image;
  }

  Future insert(int amount, DateTime date, String deskripsi, int categoryId,
      Uint8List? imageDb) async {
    return await database.insertTransaction(
        amount, date, deskripsi, categoryId, imageDb);
  }

  Future update(int transactionId, int amount, int categoryId,
      DateTime transactionDate, String deskripsi, Uint8List? imageDb) async {
    return await database.updateTransactionRepo(
      transactionId,
      amount,
      categoryId,
      transactionDate,
      deskripsi,
      imageDb,
    );
  }

  Future insertCategory(String name, int type) async {
    DateTime now = DateTime.now();
    final row = await database.into(database.categories).insertReturning(
        CategoriesCompanion.insert(
            name: name, type: type, createdAt: now, updatedAt: now));
    print(row);
  }

  convertImageToUint8List(File image) {
    // Baca data gambar sebagai byte
    List<int> bytes = image.readAsBytesSync();

    // Konversi ke Uint8List
    Uint8List uint8List = Uint8List.fromList(bytes);

    return uint8List;
  }

  // Parameter untuk ImageInput
  File? savedImage;
  Uint8List? imageDb;
  void savedImages(File image) {
    savedImage = image;
    imageDb = convertImageToUint8List(image);
  }

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  TextEditingController categoryNameController = TextEditingController();
  // Dialog
  void openDialog(Category? category) {
    String text = (lang == 0) ? 'Tambah' : 'Add';
    if (category != null) {
      categoryNameController.text = category.name;
      text = 'Edit';
    }
    showDialog(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: isDark ? dialog : Colors.white,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            content: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      (type == 2)
                          ? (lang == 0)
                              ? '$text Kategori Pengeluaran'
                              : '$text Expense Category'
                          : (lang == 0)
                              ? '$text Kategori Pemasukan'
                              : '$text Income Category',
                      style: GoogleFonts.inder(
                        fontSize: 18,
                        color: isDark ? base : Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(
                              color: isDark ? base : Colors.black,
                            ),
                            controller: categoryNameController,
                            cursorColor: primary,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return (lang == 0)
                                    ? 'Nama kategori tidak boleh kosong'
                                    : "Category Name cannot be empty";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primary),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: isDark ? base : Colors.black,
                                  )),
                              labelText: (lang == 0)
                                  ? "Nama Kategori"
                                  : "Category Name",
                              labelStyle: TextStyle(
                                color: isDark ? base : Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(primary),
                              shape: MaterialStatePropertyAll(
                                ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (category == null &&
                                    categoryNameController.text != '') {
                                  insertCategory(
                                    categoryNameController.text,
                                    type,
                                  );
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                  setState(() {});
                                  categoryNameController.clear();
                                }
                              }
                            },
                            child: Text(
                              (lang == 0) ? 'Simpan' : 'Save',
                              style: GoogleFonts.inder(
                                color: base,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // Untuk Otomatatis langsung memasukkan ke rekap bulanan
  Future createMonthlyRekaps(int year, int month) async {
    return await database.createMonthlyRekaps(year, month);
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
                  (widget.transactionWithCategory == null)
                      ? (lang == 0)
                          ? "Tambah Transaksi"
                          : "Add Transaction"
                      : (lang == 0)
                          ? "Edit Transaksi"
                          : "Edit Transaction",
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
                padding: EdgeInsets.only(top: 0),
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
                      padding: const EdgeInsets.only(top: 10.0, bottom: 15),
                      child: Form(
                        key: _formKey1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                    color: isDark ? base : Colors.black),
                                controller: deskripsiController,
                                cursorColor: primary,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return (lang == 0)
                                        ? 'Deskripsi tidak boleh kosong'
                                        : 'Transaction Name cannot be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: isDark ? base : home),
                                  ),
                                  labelText: (lang == 0)
                                      ? 'Deskripsi'
                                      : 'Transaction Name',
                                  labelStyle: TextStyle(
                                      color: isDark ? base : Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                    color: isDark ? base : Colors.black),
                                controller: amountController,
                                keyboardType: TextInputType.number,
                                cursorColor: primary,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return (lang == 0)
                                        ? 'Jumlah uang tidak boleh kosong'
                                        : 'Amount cannot be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: isDark ? base : home),
                                  ),
                                  labelText:
                                      (lang == 0) ? 'Jumlah Uang' : 'Amount',
                                  labelStyle: TextStyle(
                                      color: isDark ? base : Colors.black),
                                ),
                              ),
                            ),

                            // SizedBox(
                            //   height: 10,
                            // ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                style: TextStyle(
                                    color: isDark ? base : Colors.black),
                                readOnly: true,
                                controller: dateController,
                                cursorColor: primary,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return (lang == 0)
                                        ? 'Tanggal tidak boleh kosong'
                                        : 'Date cannot be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: primary)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: isDark ? base : home),
                                  ),
                                  labelStyle: TextStyle(
                                      color: isDark ? base : Colors.black),
                                  labelText: (lang == 0)
                                      ? 'Pilih Tanggal'
                                      : 'Choose Date',
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
                                      initialEntryMode:
                                          DatePickerEntryMode.calendarOnly,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: primary,
                                              onPrimary: base,
                                              onSurface:
                                                  isDark ? base : Colors.black,
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
                                        : DateFormat('dd-MMMM-yyyy')
                                            .format(pickedDate!);
                                    dateController.text = formattedDate;
                                    String data = DateFormat('yyyy-MM-dd')
                                        .format(pickedDate);
                                    setState(() {
                                      dbDate = data;
                                    });
                                  }
                                },
                              ),
                            ),

                            FutureBuilder<List<Category>>(
                              future: getAllCategory(type),
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
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child:
                                            DropdownButtonFormField<Category>(
                                          dropdownColor: isDark ? card : base,
                                          style: TextStyle(
                                              color:
                                                  isDark ? base : Colors.black),
                                          validator: (value) {
                                            if (value == null) {
                                              return (lang == 0)
                                                  ? 'Kategori tidak boleh kosong'
                                                  : 'Category cannot be empty';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: isDark ? base : home),
                                            ),
                                            labelStyle: TextStyle(
                                                color: isDark
                                                    ? base
                                                    : Colors.black),
                                            labelText: (lang == 0)
                                                ? 'Pilih Kategori'
                                                : 'Category',
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: primary)),
                                          ),
                                          isExpanded: true,
                                          value: selectedCategory,
                                          icon: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 11),
                                            child: Icon(
                                              Icons.arrow_drop_down,
                                              color: primary,
                                            ),
                                          ),
                                          items: snapshot.data!
                                              .map((Category item) {
                                            return DropdownMenuItem<Category>(
                                              value: item,
                                              child: Text(item.name),
                                            );
                                          }).toList(),
                                          onChanged: (Category? value) {
                                            setState(() {
                                              selectedCategory = value;
                                            });
                                          },
                                        ),
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 24.0, horizontal: 18.0),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                (lang == 0)
                                                    ? 'Kategori tidak ada'
                                                    : 'Category not found',
                                                style: TextStyle(
                                                  color: isDark
                                                      ? base
                                                      : Colors.black,
                                                ),
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  // Navigator.pushReplacement(
                                                  //   context,
                                                  //   // DetailPage adalah halaman yang dituju
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         CategoryPage(),
                                                  //   ),
                                                  // );
                                                  openDialog(null);
                                                  categoryNameController
                                                      .clear();
                                                },
                                                icon: Icon(
                                                  Icons.add,
                                                  color: base,
                                                ),
                                                label: Text(
                                                  (lang == 0)
                                                      ? 'Tambah kategori'
                                                      : 'Add Category',
                                                  style: GoogleFonts.inder(
                                                      color: base),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    primary,
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 24.0),
                                      child: Center(
                                        child: Text(
                                          (lang == 0)
                                              ? 'Database tidak ada'
                                              : "Database not found",
                                          style: TextStyle(
                                            color: isDark ? base : Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),

                            SizedBox(
                              height: 25,
                            ),
                            (imageLama != null)
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (lang == 0)
                                                    ? "Gambar Lama"
                                                    : 'Old Image',
                                                style: GoogleFonts.montserrat(
                                                  color: isDark
                                                      ? base
                                                      : Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2, color: primary),
                                                ),
                                                child: Image.memory(
                                                  imageLama!,
                                                  fit: BoxFit.cover,
                                                  width: 200,
                                                  height: 200,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (lang == 0)
                                                    ? "Gambar Baru(opsional)"
                                                    : "New Image(Optional)",
                                                style: GoogleFonts.montserrat(
                                                    color: isDark
                                                        ? base
                                                        : Colors.black),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ImageInput(
                                                imagesaveat: savedImages,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (lang == 0)
                                              ? "Gambar (opsional)"
                                              : "Image (Optional)",
                                          style: GoogleFonts.montserrat(
                                              color:
                                                  isDark ? base : Colors.black),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ImageInput(imagesaveat: savedImages),
                                      ],
                                    ),
                                  ),
                            SizedBox(
                              height: 25,
                            ),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 20, 16, 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey1.currentState!
                                              .validate()) {
                                            if (widget
                                                    .transactionWithCategory ==
                                                null) {
                                              await insert(
                                                int.parse(
                                                    amountController.text),
                                                DateTime.parse(dbDate),
                                                deskripsiController.text,
                                                selectedCategory!.id,
                                                imageDb,
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    (lang == 0)
                                                        ? 'Berhasil Tambah Transaksi'
                                                        : 'Add Transaction Success',
                                                    style: GoogleFonts.inder(
                                                        color: base),
                                                  ),
                                                  backgroundColor: primary,
                                                ),
                                              );
                                            } else {
                                              if (widget
                                                      .transactionWithCategory !=
                                                  null) {
                                                await update(
                                                  widget
                                                      .transactionWithCategory!
                                                      .transaction
                                                      .id,
                                                  int.parse(
                                                      amountController.text),
                                                  selectedCategory!.id,
                                                  DateTime.parse(dbDate),
                                                  deskripsiController.text,
                                                  imageDb,
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      (lang == 0)
                                                          ? 'Berhasil Edit Transaksi'
                                                          : 'Edit Transaction Success',
                                                      style: GoogleFonts.inder(
                                                          color: base),
                                                    ),
                                                    backgroundColor: primary,
                                                  ),
                                                );
                                              }
                                            }

                                            // Parsing string tanggal ke dalam objek DateTime
                                            DateTime date =
                                                DateTime.parse(dbDate);

                                            // Mendapatkan tahun dan bulan dari objek DateTime
                                            int year = date.year;
                                            int month = date.month;

                                            await createMonthlyRekaps(
                                                year, month);
                                            // Navigator.pop(context);

                                            final route = MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                selectedDate:
                                                    DateTime.parse(dbDate),
                                              ),
                                            );
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    route, (route) => false);
                                          }
                                        },
                                        child: Text(
                                          (lang == 0)
                                              ? 'Simpan Transaksi'
                                              : 'Save',
                                          style: GoogleFonts.inder(
                                            color: base,
                                            fontSize: 15,
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              // (isExpense) ? MaterialStateProperty.all<Color>(Colors.red) :
                                              MaterialStateProperty.all<Color>(
                                                  primary),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
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
                      ),
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
