import 'package:camera/camera.dart';
import 'package:drink_less/pages/take_picture.dart';
import 'package:flutter/material.dart';

import 'package:drink_less/extra/footer.dart';
import 'package:drink_less/extra/header.dart';

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
      appBar: CustomAppBar(),

      body: Center(
        child: ElevatedButton(
          onPressed: () async => await takePicture(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Green background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Curved edges
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
          child: Text(
            "Start Test",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white, // White text
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
