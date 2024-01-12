import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  static const String Connect = "https://6f25-103-127-65-56.ngrok-free.app/api";

  static Future<Map<String, dynamic>> checkQRCodeValidity(String qrCode) async {
    try {
      final response = await http.post(
        Uri.parse('$Connect/validate-qrcode-api?barcodeScanRes=$qrCode'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body as JSON
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to check QR code validity: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print("Network error: $e");
      throw e;
    } catch (e) {
      print("Error checking QR code validity: $e");
      throw Exception('Failed to check QR code validity');
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
