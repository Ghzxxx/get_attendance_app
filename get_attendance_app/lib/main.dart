import 'package:flutter/material.dart';
import 'package:get_attendance_app/qrcode_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_attendance_app/splashscreen.dart';
import 'package:get_attendance_app/home.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermission();

  runApp(MyApp());
}

Future<void> requestLocationPermission() async {
  final status = await Permission.location.request();

  if (status.isGranted) {
    // Permission granted, you can now proceed with location-related tasks
    startLocationTracking();
    print('Location permission granted');
    runApp(MyApp());
  } else if (status.isDenied) {
    // Permission denied, handle it or show a message to the user
    print('Location permission denied');
    Map<Permission,PermissionStatus> status = await [Permission.location,
    ].request();
  } else if (status.isPermanentlyDenied) {
    // Permission permanently denied, open app settings to allow permission
    openAppSettings();
    print('Location permission permanently denied');
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fingerprint Auth",
      initialRoute: '/splash', // Set the initial route to splash
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => HomePage(),
        '/qr': (context) => QRCodeScreen(),




      },
    );
  }
}
