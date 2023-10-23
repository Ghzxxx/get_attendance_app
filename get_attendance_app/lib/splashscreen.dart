import 'package:flutter/material.dart';
import 'package:get_attendance_app/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // Simulate some loading or initialization process
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _loading = false;
      });
    });

    // Delay for a moment before navigating to the login page
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/home'); // Navigate to home page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedOpacity(
        opacity: _loading ? 1.0 : 0.0,
        duration: Duration(seconds: 2), // Adjust the duration as needed
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logofix.png'),
              SizedBox(height: 16.0),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

