import 'package:flutter/material.dart';
import 'package:get_attendance_app/qr_utils.dart';
import 'package:get_attendance_app/face_scan_scaneer.dart'; // Ubahlah sesuai dengan nama file yang benar

class QRCodeScreen extends StatefulWidget {
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String barcode = "";

  @override
  void initState() {
    super.initState();
    _scanQR();
  }

  void _scanQR() async {
    String? barcodeScanRes = await QRUtils.scanQR();
    if (barcodeScanRes != null) {
      setState(() {
        barcode = barcodeScanRes;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FaceScanScreen()), // Ubahlah sesuai dengan nama file yang benar
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Scan result: $barcode'),
          ],
        ),
      ),
    );
  }
}
