import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class DataPage extends StatefulWidget {
  final File imageFile;

  DataPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late List<Map<String, dynamic>> dataOptions = [];
  Map<String, dynamic> selectedData = {};

  @override
  void initState() {
    super.initState();
    fetchDataOptions();
  }

  Future<void> fetchDataOptions() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/api/peserta-names'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        List<Map<String, dynamic>> options = List<Map<String, dynamic>>.from(responseData);
        setState(() {
          dataOptions = options;
        });
      } else {
        print('Failed to fetch data options. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data options: $e');
    }
  }

  Future<void> sendAttendanceData(int selectedId) async {
    // Replace the following with your actual API endpoint and logic to send data to the database
    final apiUrl = 'http://10.0.2.2/api/receive-data';
    final Map<String, dynamic> requestData = {
      'selectedId': selectedId,
      // Add any additional data you want to send to the database
    };

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      // Add other form data to the request
      requestData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final response = await request.send();

      if (response.statusCode == 200) {
        // Handle successful response
        print('Attendance data and image sent successfully');
      } else {
        // Handle error response
        print('Failed to send attendance data and image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending attendance data and image: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade500,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                "Choose Name ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: dataOptions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${dataOptions[index]['id']} - ${dataOptions[index]['name']}'),
                    tileColor: selectedData == dataOptions[index] ? Colors.blue : null,
                    onTap: () {
                      setState(() {
                        selectedData = dataOptions[index];
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              width: double.infinity,
              child: FloatingActionButton(
                onPressed: () {
                  if (selectedData.isNotEmpty) {
                    // Implement your logic when the user clicks the button
                    sendAttendanceData(selectedData['id']);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Please select a data option before sending.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
                  child: Text(
                    "Attend",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

