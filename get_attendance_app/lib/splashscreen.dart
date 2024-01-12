import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    // Delay for a moment before navigating to the next screen
    Future.delayed(Duration(seconds: 3), () {
      _checkLocationAndNavigate();
    });
  }

  Future<void> _checkLocationAndNavigate() async {
    // Check if the location is within 5-10 meters from the target coordinates
    final targetCoordinates = Position(
      latitude: -8.132937,
      longitude: 112.563975,
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      timestamp: DateTime.now(),
    );
    final currentCoordinates = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,


    );

    final distanceInMeters = Geolocator.distanceBetween(
      targetCoordinates.latitude,
      targetCoordinates.longitude,
      currentCoordinates.latitude,
      currentCoordinates.longitude,
    );

    if (distanceInMeters <= 15) {
      Navigator.of(context).pushReplacementNamed('/qrcode');
      print('Location is on range');// Navigate to the next screen
    } else {
      Navigator.of(context).pushReplacementNamed('/far');
      print('Location far');// Navigate to the location denied screen
    }
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
