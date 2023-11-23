import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late List<String> dataOptions = []; // Initialize to an empty list

  String selectedData = "";

  @override
  void initState() {
    super.initState();
    // Fetch data from the web API when the widget is initialized
    fetchDataOptions();
  }

  Future<void> fetchDataOptions() async {
    final apiUrl = 'https://testingapi';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {

        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          dataOptions = responseData.map((data) => data.toString()).toList();
        });
      } else {

        print('Failed to fetch data options. Status code: ${response.statusCode}');
      }
    } catch (e) {

      print('Error fetching data options: $e');
    }
  }

  Future<void> sendAttendanceData() async {
    // Replace the following with your actual API endpoint and logic to send data to the database
    final apiUrl = 'https://testingapi';
    final Map<String, dynamic> requestData = {
      'selectedData': selectedData,
      // Add any additional data you want to send to the database
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('Attendance data sent successfully');
      } else {
        // Handle error response
        print('Failed to send attendance data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network error
      print('Error sending attendance data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade500,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 300.0, horizontal: 24.0),
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
            DropdownButtonFormField<String>(
              value: selectedData,
              onChanged: (String? newValue) {
                setState(() {
                  selectedData = newValue!;
                });
              },
              items: dataOptions
                  .map((option) => DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              ))
                  .toList() ??
                  [],
              hint: Text('Choose Name'),
            ),
            SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              width: double.infinity,
              child: FloatingActionButton(
                onPressed: () {
                  // Validate that a data option is selected before sending to the database
                  if (selectedData.isNotEmpty) {
                    sendAttendanceData();
                  } else {
                    // Show an error message if no data option is selected
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
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 14.0),
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
