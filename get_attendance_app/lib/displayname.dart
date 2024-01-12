import 'dart:convert';
import 'dart:io';
import 'ThankYouPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DisplayNamesPage extends StatefulWidget {
  final File imageFile;

  DisplayNamesPage({required this.imageFile});

  @override
  _DisplayNamesPageState createState() => _DisplayNamesPageState();
}

class _DisplayNamesPageState extends State<DisplayNamesPage> {
  late List<Map<String, dynamic>> dataOptions;
  Map<String, dynamic>? selectedData;

  @override
  void initState() {
    super.initState();
    dataOptions = [];
    selectedData = null;
    fetchDataOptions();
  }

  Future<void> fetchDataOptions() async {
    try {
      final response = await http.get(Uri.parse('https://6f25-103-127-65-56.ngrok-free.app/api/peserta-names'));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        List<String> names = List<String>.from(responseData['names']);
        List<Map<String, dynamic>> namesData = names
            .map((name) => {'name': name, 'id': names.indexOf(name) + 1})
            .toList();
        setState(() {
          dataOptions = namesData;
        });
      } else {
        print('Failed to fetch data options. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data options: $e');
    }
  }

  Future<void> sendAttendanceData(int selectedId) async {
    if (selectedData != null) {


      // Replace the following with your actual API endpoint and logic to send data to the database
      final apiUrl = 'https://6f25-103-127-65-56.ngrok-free.app/api/receive-data';

      final Map<String, dynamic> requestData = {
        'selectedId': selectedId.toString(),
      };

      try {
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
        requestData.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        request.files.add(http.MultipartFile(
          'image',
          widget.imageFile.readAsBytes().asStream(),
          widget.imageFile.lengthSync(),
          filename: 'image.jpg',
        ));

        final response = await request.send();

        if (response.statusCode == 200) {
          print('Attendance data and image sent successfully');

          // Show dialog and navigate to ThankYouPage
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Anda sudah login'),
                content: Text('Terima kasih sudah login.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ThankYouPage()),
                      );
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          print('Failed to send attendance data and image. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error sending attendance data and image: $e');
      }
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
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade500,
      body: Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.only(top: 24.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                "Pilih Nama Anda ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: dataOptions.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0), // Sesuaikan dengan tingkat kebulatan yang diinginkan
                    ),
                    child: ListTile(
                      title: Text(
                        dataOptions[index]['name'],
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      tileColor: selectedData == dataOptions[index] ? Color(0xFF2D3250) : Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Sesuaikan dengan tingkat kebulatan yang diinginkan
                      ),
                      onTap: () {
                        setState(() {
                          selectedData = dataOptions[index];
                        });
                      },
                    ),
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
                  if (selectedData != null) {
                    sendAttendanceData(selectedData!['id']);
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
                    style: TextStyle(color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                    ),
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
