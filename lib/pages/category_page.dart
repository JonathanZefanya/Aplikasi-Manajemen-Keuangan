import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:sisaku/colors.dart';
import 'package:tangan/models/database.dart';
import 'package:tangan/pages/home_page.dart';
import 'package:tangan/pages/rekap_page.dart';
import 'package:tangan/pages/setting_page.dart';
import 'package:tangan/widgets/switch_button.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _formKey = GlobalKey<FormState>();
  late int type;

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

  final AppDb database = AppDb();

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    final row = await database.into(database.categories).insertReturning(
        CategoriesCompanion.insert(
            name: name, type: type, createdAt: now, updatedAt: now));
    print(row);
  }

  Future update(int categoryId, String newName) async {
    return await database.updateCategoryRepo(categoryId, newName);
  }

  TextEditingController categoryNameController = TextEditingController();
  // Dialog
  void openDialog(Category? category) {
    String text = (lang == 0) ? 'Tambah' : "Add";
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
                          fontSize: 18, color: isDark ? base : home),
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
                                color: isDark ? Colors.white : Colors.black),
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
                              filled: isDark ? true : false,
                              fillColor: isDark ? card : null,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primary),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: isDark ? base : Colors.black,
                                ),
                              ),
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
                                  insert(
                                    categoryNameController.text,
                                    type,
                                  );
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                  setState(() {});
                                  categoryNameController.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        (lang == 0)
                                            ? 'Berhasil Tambah Kategori'
                                            : "Add Category Success",
                                        style: GoogleFonts.inder(color: base),
                                      ),
                                      backgroundColor: primary,
                                    ),
                                  );
                                } else {
                                  if (category != null &&
                                      categoryNameController.text != '') {
                                    update(
                                      category.id,
                                      categoryNameController.text,
                                    );
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                    setState(() {});
                                    categoryNameController.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          (lang == 0)
                                              ? 'Berhasil Edit Kategori'
                                              : "Edit Category Success",
                                          style: GoogleFonts.inder(color: base),
                                        ),
                                        backgroundColor: primary,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: Text(
                              (lang == 0) ? 'Simpan' : "Save",
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
                  (lang == 0) ? "Kategori" : "Category",
                  style: GoogleFonts.inder(
                    fontSize: 23,
                    color: base,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Widget dibuat sendiri pake animasi
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
                decoration: BoxDecoration(
                  color: isDark ? background : base,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: SafeArea(
                  // mulai dari sini coyy

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 16,
                          top: 10,
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(primary),
                            shape: MaterialStatePropertyAll(
                              ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          onPressed: () {
                            openDialog(null);
                            categoryNameController.clear();
                          },
                          child: Text(
                            (lang == 0) ? 'Tambah' : "Add",
                            style: GoogleFonts.inder(
                              color: base,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<Category>>(
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
                                    shrinkWrap: true,
                                    itemCount: snapshot.data?.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Card(
                                            color: isDark ? card : base,
                                            elevation: 10,
                                            child: ListTile(
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color:
                                                          isDark ? base : home,
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              backgroundColor:
                                                                  isDark
                                                                      ? dialog
                                                                      : Colors
                                                                          .white,
                                                              shadowColor:
                                                                  Colors
                                                                      .red[50],
                                                              content:
                                                                  SingleChildScrollView(
                                                                child: Center(
                                                                  child: Column(
                                                                    children: [
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          (lang == 0)
                                                                              ? 'Yakin ingin Hapus?'
                                                                              : "Are you sure want to delete this category?",
                                                                          style:
                                                                              GoogleFonts.inder(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: isDark
                                                                                ? base
                                                                                : home,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              (lang == 0) ? 'Batal' : "Cancel",
                                                                              style: GoogleFonts.inder(
                                                                                color: isDark ? base : home,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          ElevatedButton(
                                                                            style:
                                                                                ButtonStyle(
                                                                              backgroundColor: MaterialStatePropertyAll(primary),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                              database.deleteCategoryAndTransactionsRepo(snapshot.data![index].id);
                                                                              setState(() {});
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(
                                                                                    content: Text(
                                                                                      (lang == 0) ? 'Berhasil Hapus Kategori' : "Delete Category Success",
                                                                                      style: GoogleFonts.inder(color: base),
                                                                                    ),
                                                                                    backgroundColor: primary),
                                                                              );
                                                                            },
                                                                            child:
                                                                                Text(
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
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color:
                                                          isDark ? base : home,
                                                    ),
                                                    onPressed: () {
                                                      openDialog(snapshot
                                                          .data![index]);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              leading: Container(
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: (type == 2)
                                                    ? Icon(Icons.upload,
                                                        color: Colors
                                                            .redAccent[400])
                                                    : Icon(
                                                        Icons.download,
                                                        color: Colors
                                                            .greenAccent[400],
                                                      ),
                                              ),
                                              title: Text(
                                                snapshot.data![index].name,
                                                style: TextStyle(
                                                    color:
                                                        isDark ? base : home),
                                              ),
                                            ),
                                          ).animate()
                                                        .fade(begin: 0.5)
                                                        .then()
                                                        .slideX(begin: 0.7),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      (lang == 0)
                                          ? 'Data tidak ada'
                                          : "No data",
                                      style: TextStyle(
                                        color: isDark ? base : home,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return Center(
                                  child: Text(
                                    (lang == 0) ? 'Data tidak ada' : "No data",
                                    style: TextStyle(
                                      color: isDark ? base : home,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          future: getAllCategory(type),
                        ),
                      ),
                    ],
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
                  color: primary,
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
