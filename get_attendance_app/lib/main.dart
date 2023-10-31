import 'package:flutter/material.dart';
import 'package:get_attendance_app/qrcode_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_attendance_app/splashscreen.dart';
import 'package:get_attendance_app/home.dart';
import 'package:get_attendance_app/locationdeniedscreen.dart';
import 'package:camera/camera.dart';

import 'facemcapture.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(await determineStartingScreen());
}

Future<void> initializeCameraAndPermissions() async {
  // Initialize the camera
  final cameras = await availableCameras();
  CameraDescription camera = cameras.first; // Choose the desired camera
  CameraController cameraController = CameraController(camera, ResolutionPreset.high);
  await cameraController.initialize();

  // Initialize location permission
  await Permission.location.request();
}

Future<Widget> determineStartingScreen() async {
  if (await Permission.location.isDenied) {
    // Permission denied, request location permission again
    await Permission.location.request();
    await Permission.camera.request();
  }

  if (await Permission.location.isGranted && await Permission.camera.isGranted) {
    // Permission granted, you can now proceed with location-related tasks
    startLocationTracking();
    print('Location permission granted');
    return MyApp();
  } else {
    // Return the location denied screen
    return MaterialApp(
      home: LocationDeniedScreen(),
    );
  }
}

void startLocationTracking() {
  Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best, distanceFilter: 10)
      .listen((Position position) {
    // You can access the current location using the 'position' object.
    // Handle location updates here.
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  });
}

class MyApp extends StatelessWidget {
  static final navKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: navKey,
      debugShowCheckedModeBanner: false,
      title: "Attendance App",
      initialRoute: '/splash', // Set the initial route to splash
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => HomePage(),
        '/qr': (context) => QRCodeScreen(),
      },
    );
  }
}
