import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({
    super.key, required Null Function() onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Image.asset(
            "assets/nokoneksi.png",
            fit: BoxFit.cover,
            width: 250,
            height: 250,
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Tidak Ada Koneksi Internet",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Minta Hospot Teman mu bruh, transaksi aja gk ada apalagi kuota",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          )
        ],  
      ),
    );
  }
}
