import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'attendance_page.dart';

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
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendancePage(imagePath: picture.path),
        ),
      );
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
              child: GestureDetector(
                onTap: takePicture,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.camera_alt,
                    size: 40.0,
                    color: Colors.black,
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
