import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get_attendance_app/splashscreen.dart';
import 'package:flutter/services.dart';

class LocationFarScreen extends StatelessWidget {
  Future<void> requestLocationPermission(BuildContext context) async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      // Permission granted, you can now proceed with location-related tasks
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
    }
  }

  Future<void> exitApp() async {
    if (Platform.isAndroid || Platform.isIOS) {
      exit(0); // This will exit the app on Android and iOS
    } else {
      // Handle other platforms if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade500,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Your location is Too Far Away from Get Aplikasi Indonesia Office ",
                textAlign: TextAlign.center,
                style: TextStyle(

                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,

                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              child: const Text(
                "Your Location Must At Least within 10 meters away from Get Aplikasi Indonesia Office",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, height: 1.5, fontSize: 12),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              width: double.infinity,
              child: FloatingActionButton(
                onPressed: exitApp,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 14.0),
                  child: Text(
                    "Exit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )



          ],
        ),
      ),
    );
  }
}
