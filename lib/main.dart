import 'package:flutter/material.dart';
import 'screens/home.dart';

import 'screens/root.dart';
import 'store/store.dart';
import 'screens/consts.dart';

void main() {
  runApp(
      /*ChangeNotifierProvider<Store>(
      create: (context) => Store(),
      child: TheApp(), 
    )*/
      TheApp());
}

class TheApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'title of app',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.green,
        backgroundColor: Colors.grey,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
          bodyText1: TextStyle(fontSize: 7, color: Colors.black),
          bodyText2: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: RootScreen(),
      home: HomeScreen(),
      initialRoute: '/',
      routes: {
        //some example screen that might be used
        '/home': (context) => RootScreen(SCREEN_HOME),
        '/settings': (context) => RootScreen(SCREEN_SETTINGS),
      },
    );
  }
}
