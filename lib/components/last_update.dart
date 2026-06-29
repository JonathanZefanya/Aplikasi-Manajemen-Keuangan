import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tangan/pages/setting_page.dart';

class LastUpdate extends StatelessWidget {
  final String date;

  LastUpdate({required this.date});

  String _formatDate() {
    final parsedDate = DateTime.tryParse(date);
    if (parsedDate == null) return date;
    return DateFormat('dd MMMM yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 24, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.date_range,
                color: Colors.black26,
                size: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  "Last Update ${_formatDate()}",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black54),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text('Kelompok DevTangan',
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.black54,
                      fontSize: 13)),
              GestureDetector(
                onTap: () {
                  _launchURL('https://jojo.tirtagt.xyz/#project');
                },
                child: Text(
                  'Source Code',
                  style: TextStyle(fontSize: 13, color: Colors.lightBlueAccent),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  _launchURL(String url) async {
    Uri urlUri = Uri.parse(url);
    if (await canLaunchUrl(urlUri)) {
      await launchUrl(urlUri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
