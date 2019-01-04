import 'package:dreamwithme/clients/dreamwidth.dart';
import 'package:dreamwithme/pages/friends.dart';
import 'package:dreamwithme/pages/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(DreamWithMe());

class DreamWithMe extends StatelessWidget {
  static DreamWidthClient client = DreamWidthClient();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream With Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: const Color(0xFF880015),
        primaryColorDark: const Color(0xFF7D2E3B),
        accentColor: const Color(0xFFC78193),

        // TODO: create a custom primary swatch
        //primarySwatch: Colors.red

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        // textTheme: TextTheme(
        //   headline: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black38),
        //   subhead: TextStyle(fontSize: 14.0, color: Colors.white),
        // )
      ),
      home: LoginPage(client: client),
      routes: <String, WidgetBuilder> {
        LoginPage.tag: (context) => LoginPage(client: client),
        FriendsPage.tag: (context) => FriendsPage(client: client),
      },
    );
  }
}
