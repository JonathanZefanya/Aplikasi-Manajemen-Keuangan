import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String msg;
  final VoidCallback onPressed;

  ErrorMessage({required this.msg, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Koneksi Internet tidak ada\n$msg"),
        Image.asset(
          "assets/img/logo.png",
          fit: BoxFit.cover,
          width: 250,
          height: 250,
        ),
        OutlinedButton(
          onPressed: onPressed,
          child: Text(
            "Try Again",
            style: TextStyle(color: Colors.lightBlue),
          ),
        )
      ],
    );
  }
}