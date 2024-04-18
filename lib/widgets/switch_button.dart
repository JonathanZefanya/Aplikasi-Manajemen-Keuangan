import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:sisaku/colors.dart';
import 'package:tangan/pages/setting_page.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({
    super.key,
    required this.type,
    required this.updateType,
  });
  final type;
  final updateType;
  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? home : base,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: (widget.type == 1)
                            ? primary.withAlpha(170)
                            : base.withOpacity(0.75),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          topLeft: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Kalo dipilih ada Animasiny
                          (widget.type == 1)
                              ? Icon(
                                      //Animasi Untuk Icon
                                      Icons.download_outlined,
                                      color: base)
                                  .animate()
                                  .fadeIn(duration: 500.ms)
                                  .then(delay: 30.ms)
                                  .tint(
                                      color: Colors.greenAccent,
                                      delay: Duration(milliseconds: 50))
                                  .then()
                                  .shake(duration: 4000.ms)
                              // Kalo tidak dipilih
                              : Icon(
                                  Icons.download_outlined,
                                  color: Colors.green[300],
                                ),

                          TextButton(
                            onPressed: () {
                              widget.updateType(1);
                            },
                            // Kalo dipilih ada Animasiny
                            child: (widget.type == 1)
                                ? Text(
                                    (lang == 0) ? "Pemasukan" : "Income",
                                    style: GoogleFonts.inder(
                                        fontSize: 15,
                                        color: base,
                                        fontWeight: FontWeight.bold),
                                  )
                                    .animate()
                                    .fadeIn(duration: 500.ms)
                                    .then(delay: 30.ms) // baseline=800ms
                                    .slide()
                                    .tint(
                                        color: isDark
                                            ? Colors.greenAccent
                                                .withOpacity(0.25)
                                            : base,
                                        delay: Duration(milliseconds: 50))

                                // Kalo dk dipilih ga ada animasinya
                                : Text(
                                    (lang == 0) ? "Pemasukan" : "Income",
                                    style: GoogleFonts.inder(
                                        color: primary,
                                        fontWeight: FontWeight.normal),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: (widget.type == 2)
                            ? primary.withAlpha(170)
                            : base.withOpacity(0.75),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              widget.updateType(2);
                            },
                            // Kalo dipilih ada Animasiny
                            child: (widget.type == 2)
                                ? Text(
                                    (lang == 0) ? "Pengeluaran" : "Expense",
                                    style: GoogleFonts.inder(
                                        fontSize: 15,
                                        color: base,
                                        fontWeight: FontWeight.bold),
                                  )
                                    .animate()
                                    .fadeIn(duration: 500.ms)
                                    .then(delay: 30.ms) // baseline=800ms
                                    .slide()
                                    .tint(
                                        color: isDark
                                            ? Colors.red.withOpacity(0.6)
                                            : base,
                                        delay: Duration(milliseconds: 50))

                                // Kalo dk dipilih ga ada animasinya
                                : Text(
                                    (lang == 0) ? "Pengeluaran" : "Expense",
                                    style: GoogleFonts.inder(
                                        color: primary,
                                        fontWeight: FontWeight.normal),
                                  ),
                          ),
                          (widget.type == 2)
                              ? Icon(
                                      //Animasi Untuk Icon
                                      Icons.upload_outlined,
                                      color: base)
                                  .animate()
                                  .fadeIn(duration: 500.ms)
                                  .then(delay: 30.ms)
                                  .tint(
                                      color: Colors.red.withOpacity(0.7),
                                      delay: Duration(milliseconds: 50))
                                  .then()
                                  .shake(duration: 4000.ms)
                              : Icon(
                                  Icons.upload_outlined,
                                  color: Colors.red[300],
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
    ).animate().fade().slide(duration: 400.ms);
  }
}
