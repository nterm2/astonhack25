import 'package:camera/camera.dart';
import 'package:drink_less/pages/take_picture.dart';
import 'package:flutter/material.dart';

class StartTestPage extends StatelessWidget {
  const StartTestPage({super.key});
 
  Future<void> takePicture(BuildContext context) async {
    final cameras = await availableCameras();
    final fCam = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
    );

    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TakePictureScreen(camera: fCam)),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome to Drink Less")),
      body: Center(
        child: TextButton(
          onPressed: () async => await takePicture(context),
          child: Text("Start Test"),
        ),
      ),
    );
  }
}
