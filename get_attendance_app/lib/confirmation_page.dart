import 'package:flutter/material.dart';

class ConfirmationPage extends StatelessWidget {
  final String barcodeResult;

  ConfirmationPage({required this.barcodeResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Confirmation Page'),
            Text('Barcode Result: $barcodeResult'),
            // Add your face confirmation widget here
          ],
        ),
      ),
    );
  }
}
