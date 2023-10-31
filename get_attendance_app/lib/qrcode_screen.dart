import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_attendance_app/face_scan_scaneer.dart';
import 'package:get_attendance_app/home.dart';
import 'package:get_attendance_app/qr_utils.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:camera/camera.dart';
import 'facemcapture.dart'; // Pastikan impor ini ada

class QRCodeScreen extends StatefulWidget {
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String barcode = "";
  CameraDescription? camera; // Define the 'camera' variable here
  CameraController? _controller;


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
      if (_controller != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FaceCapturePage(controller: _controller!),
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


          ],
        ),
      ),
    );
  }
}
