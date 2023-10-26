import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get_attendance_app/attendance_page.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';



class FaceScanScreen extends StatefulWidget {
  @override
  _FaceScanScreenState createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends State<FaceScanScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int _timerSeconds = 5;
  bool _isTimerActive = false;
  late String _imageName;
  late String _fileName;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front);
    _controller = CameraController(frontCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  void startTimer() {
    _isTimerActive = true;
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
          startTimer();
        } else {
          _isTimerActive = false;
          _captureImage();
        }
      });
    });
  }

  void _captureImage() async {
    try {
      await _initializeControllerFuture;
      final XFile image = await _controller.takePicture();
      final appDir = await getApplicationDocumentsDirectory();
      _fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
      final savedImage = File('${appDir.path}/$_fileName');
      final bytes = await File(image.path).readAsBytes();
      await savedImage.writeAsBytes(bytes);
      print('Gambar disimpan sebagai $_fileName');
      _imageName = _fileName;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AttendancePage(imagePath: savedImage.path)),
      );
    } catch (e) {
      print(e);
    }
  }






  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Scanner'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!_isTimerActive) {
              startTimer();
            }
            return Stack(
              children: [
                CameraPreview(_controller),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Waktu tersisa: $_timerSeconds',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
