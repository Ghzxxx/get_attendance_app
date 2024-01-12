import 'dart:io';
import 'package:Absensi_Magang_Get/face_scan_scaneer.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'api.dart';

class QRCodeScreen extends StatefulWidget {
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String barcode = "";
  late CameraDescription camera;


  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _scanQR();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      camera = cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front);
    }
  }

  void _scanQR() async {
    try {
      String? barcodeScanRes = await scanner.scan();
      print("Scanned QR Code: $barcodeScanRes");

      if (barcodeScanRes != null) {
        Map<String, dynamic> response = await API.checkQRCodeValidity(barcodeScanRes);

        String status = response['status'];
        String message = response['message'] ?? 'No message available';

        if (status == 'success') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CameraPage(cameras: [camera]),
            ),
          );
        } else {
          // Show invalid QR code message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("QR Code Error"),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      _scanQR(); // Scan again
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      print("Error scanning QR code: $e");
    }
  }

    bool simulateApiResponse(String qrCode) {
      // Simulate logic to determine if the QR code is valid
      // For example, you might check if the QR code matches a predefined list
      List<String> validQRCodeList = [
        'testinggetandroidqrcode1'
      ]; // Replace with your valid QR codes
      return validQRCodeList.contains(qrCode);
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
