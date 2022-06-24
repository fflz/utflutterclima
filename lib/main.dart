import 'package:flutter/material.dart';
import 'package:utflutterclima/screens/home_screen.dart';
import 'package:utflutterclima/screens/login_screen.dart';

import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

final routes = {
  '/login': (BuildContext context) => new LoginPage(),
  '/': (BuildContext context) => new LoginPage(),
  '/register': (BuildContext context) => new registerPage(),
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTFlutter Clima',
      routes: routes,
    );
  }
}
