import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class SendImagePage extends StatefulWidget {
  final String imagePath; // This is the path of the captured image

  SendImagePage({required this.imagePath});

  @override
  _SendImagePageState createState() => _SendImagePageState();
}

class _SendImagePageState extends State<SendImagePage> {
  Future<void> sendImageToApi(String imagePath) async {
    // Replace with your API endpoint
    final apiUrl = 'your_api_endpoint_here';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'imagePath': imagePath},
    );

    if (response.statusCode == 200) {
      // Image sent successfully
      print('Image sent to the API');
    } else {
      // Handle the error, e.g., display an error message
      print('Failed to send image to the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Image Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the image here, you can use Image.file
            Image.file(File(widget.imagePath)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendImageToApi(widget.imagePath);
              },
              child: Text('Send Image'),
            ),
          ],
        ),
      ),
    );
  }
}
