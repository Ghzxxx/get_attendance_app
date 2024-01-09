import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import services

class ThankYouPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terima Kasih'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Terima kasih sudah login!',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Exit the app when the button is pressed
                SystemNavigator.pop(); // Exit the app
              },
              child: Text('Keluar App'),
            ),
          ],
        ),
      ),
    );
  }
}
