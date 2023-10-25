import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner; // Pastikan impor ini ada


class QRUtils {
  static Future<String?> scanQR() async {
    bool isCameraPermissionGranted = await _requestCameraPermission();

    if (isCameraPermissionGranted) {
      try {
        String? barcodeScanRes = await scanner.scan();
        return barcodeScanRes;
      } on PlatformException catch (e) {
        if (e.code == scanner.CameraAccessDenied) {
          return 'Camera permission not granted';
        } else {
          return 'Unknown error: $e';
        }
      }
    } else {
      return 'Camera permission not granted';
    }
  }

  static Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.request();
    return status.isGranted;
  }
}
