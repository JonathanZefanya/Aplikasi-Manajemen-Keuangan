import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoDialog extends StatelessWidget {
  _launchURL(String url) async {
    Uri urlUri = Uri.parse(url);
    if (await canLaunchUrl(urlUri)) {
      await launchUrl(urlUri);
  } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Credit Source'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('API', style: TextStyle(color: Colors.black45)),
            GestureDetector(
              onTap: () {
                _launchURL('https://exchangeratesapi.io');
              },
              child: Text(
                'https://exchangeratesapi.io',
                style: TextStyle(fontSize: 13, color: Colors.lightBlueAccent),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text('Theme', style: TextStyle(color: Colors.black45)),
            GestureDetector(
              onTap: () {
                _launchURL(
                    'https://www.uplabs.com/posts/mobile-app-currency-convertor');
              },
              child: Text(
                'https://www.uplabs.com/posts/mobile-app-currency-convertor',
                style: TextStyle(fontSize: 13, color: Colors.lightBlueAccent),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text('NoirDev', style: TextStyle(color: Colors.black45)),
            GestureDetector(
              onTap: () {
                _launchURL('https://jojo.tirtagt.xyz/#project');
              },
              child: Text(
                'NoirDev',
                style: TextStyle(fontSize: 13, color: Colors.lightBlueAccent),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}