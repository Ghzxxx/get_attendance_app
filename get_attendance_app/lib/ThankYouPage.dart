import 'package:flutter/material.dart';
import 'dart:io';







class ThankYouPage extends StatelessWidget {

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              child: const Text(
                "Terima Kasih Telah Melakukan Absensi.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, height: 1.5),
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
                horizontal: 12.0, vertical: 14.0),
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
