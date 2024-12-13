import 'package:tangan/components/item_currency.dart';
import 'package:tangan/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tangan/components/no_connection.dart';

class SelectCurrency extends StatefulWidget {
  final Currency currency;
  SelectCurrency({required this.currency});

  @override
  _SelectCurrencyState createState() => _SelectCurrencyState();
}

class _SelectCurrencyState extends State<SelectCurrency> {
  List<Currency> currencies = getDataCurrency();
  final Connectivity connectivity = Connectivity();
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await connectivity.checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Currency",
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.close,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: isConnected
          ? Padding(
              padding: const EdgeInsets.only(bottom: 54.0),
              child: ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final x = currencies[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.pop(context, x);
                      });
                    },
                    child: ItemCurrency(
                      x,
                      x.key == widget.currency.key ? true : false,
                      isDark: false,
                    ),
                  );
                },
              ),
            )
          : NoInternet(onPressed: () {
              _checkInternetConnection();
            }
            ),
    );
  }
}