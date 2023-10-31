import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class FaceCapturePage extends StatefulWidget {
  final CameraController? controller;

  FaceCapturePage({required this.controller});

  @override
  _FaceCapturePageState createState() => _FaceCapturePageState();
}

class _FaceCapturePageState extends State<FaceCapturePage> {
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _initializeControllerFuture = widget.controller!.initialize();
    } else {
      // Handle the case when the controller is null
    }
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  void _captureImage() async {
    if (widget.controller == null || widget.controller!.value.isTakingPicture) {
      return;
    }

    try {
      await _initializeControllerFuture;
      final XFile image = await widget.controller!.takePicture();
      // You can do something with the captured image here
      Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Manual Capture'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: CameraPreview(widget.controller!),
                ),
                ElevatedButton(
                  onPressed: _captureImage,
                  child: Text('Capture'),
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

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: Center(
        child: Text('This is the next page after manual capture.'),
      ),
    );
  }
}
