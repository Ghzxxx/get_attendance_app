import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_attendance_app/face_scan_scaneer.dart';
import 'package:qrscan/qrscan.dart' as scanner;


class QRCodeScreen extends StatefulWidget {
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String barcode = "";
  late CameraDescription camera; // Change to 'late' modifier

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // Initialize the camera here
    _scanQR();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      camera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    }
  }

  void _scanQR() async {
    String? barcodeScanRes = await scanner.scan();
    if (barcodeScanRes != null) {
      setState(() {
        barcode = barcodeScanRes;
      });
      if (camera != null) { // Change '_controller' to 'camera'
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraPage(cameras: [camera],),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your widgets here
          ],
        ),
      ),
    );
  }
}
