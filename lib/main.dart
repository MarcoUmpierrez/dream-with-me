import 'package:dreamwithme/clients/dreamwidth.dart';
import 'package:dreamwithme/pages/journal.dart';
import 'package:dreamwithme/pages/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(DreamWithMe());

class DreamWithMe extends StatelessWidget {
  static DreamWidthClient client = DreamWidthClient();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream With Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF880015),
        primaryColorDark: const Color(0xFF7D2E3B),
        accentColor: const Color(0xFFC78193)
      ),
      home: LoginPage(),
      routes: <String, WidgetBuilder> {
        LoginPage.tag: (context) => LoginPage(),
        JournalPage.tag: (context) => JournalPage(
          title: 'Reading',
          getEntries: () {
            if (client.currentUser != null) {
              return client.getReadPage();
            } else {
              return null;
            }
          },
          reloadDisabled: false,
        ),
      },
    );
  }
}
