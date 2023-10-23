import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FaceScanPage extends StatefulWidget {
  @override
  _FaceScanPageState createState() => _FaceScanPageState();
}

class _FaceScanPageState extends State<FaceScanPage> {
  late CameraController _controller;
  late FaceDetector _faceDetector;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeFaceDetector();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    await _controller.initialize();
    if (!mounted) return;
    setState(() {
      isCameraInitialized = true;
    });
  }

  void _initializeFaceDetector() {
    _faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
      enableTracking: true,
      mode: FaceDetectorMode.fast,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Scan'),
      ),
      body: Center(
        child: CameraPreview(_controller),
      ),
    );
  }
}
