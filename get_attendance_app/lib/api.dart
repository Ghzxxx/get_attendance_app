import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  static const String Connect = "http://192.168.1.6:8000/api";

  static Future<bool> checkQRCodeValidity(String qrCode) async {
    try {
      final response = await http.get(
        Uri.parse('$Connect/qrcode?barcodeScanRes=$qrCode'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to check QR code validity');
      }
    } catch (e) {
      if (e is SocketException) {
        print("Network error: $e");
      } else {
        print("Error checking QR code validity: $e");
      }
      throw e;
    }
  }

  static Future<List<String>> fetchDataOptions() async {
    try {
      final response = await http.get(Uri.parse('$Connect/peserta-names'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        List<String> names = List<String>.from(responseData['names']);
        print('Fetched data successfully: $names');
        return names;
      } else {
        print('Failed to fetch data options. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching data options: $e');
      return [];
    }
  }

  static Future<bool> sendAttendanceData(String selectedData, File imageFile) async {
    try {
      final apiUrl = '$Connect/upload-image';
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      request.fields['selectedData'] = selectedData;

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Attendance data and image sent successfully');
        return true;
      } else {
        print('Failed to send attendance data and image. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending attendance data and image: $e');
      return false;
    }
  }
}
