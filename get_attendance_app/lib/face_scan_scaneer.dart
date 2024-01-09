import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_attendance_app/sender.dart';
import 'attendance_page.dart';
import 'datapage.dart';
import 'dart:io';
import 'attendance_data.dart';

import 'displayname.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription>? cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> takePicture() async {
    if (!_isCameraReady || _cameraController.value.isTakingPicture) {
      return;
    }
    try {
      final XFile picture = await _cameraController.takePicture();
      final File imageFile = File(picture.path);
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayNamesPage(imageFile: imageFile),

        ),
      );


      if (result is AttendanceData) {
        sendAttendanceData(result.selectedData, result.imageFile);
      }
    } on CameraException catch (e) {
      debugPrint('Error occurred while taking picture: $e');
    }
  }





  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    CameraDescription? frontCamera;

    for (final camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.front) {
        frontCamera = camera;
        break;
      }
    }

    if (frontCamera != null) {
      _cameraController = CameraController(frontCamera, ResolutionPreset.high);

      try {
        await _cameraController.initialize();
        if (!mounted) return;
        setState(() {
          _isCameraReady = true;
        });
      } on CameraException catch (e) {
        debugPrint('Camera error: $e');
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraReady) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CameraPreview(_cameraController),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    color: Colors.black),
                child: Center(
                  child: IconButton(
                    onPressed: takePicture,
                    iconSize: 75,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.circle, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendAttendanceData(String selectedData, File imageFile) {}
}
