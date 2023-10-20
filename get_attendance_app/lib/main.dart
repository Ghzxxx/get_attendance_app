import 'package:flutter/material.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Attendance",
      initialRoute: '/login', // Set the initial route to splash
      routes: {
        // '/splash': (context) => SplashScreen(),
        // '/login': (context) => FingerprintAuth(),
        // '/home': (context) => HomePage(),
      },
    );
  }
}
