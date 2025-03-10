import 'package:camera/camera.dart';
import 'package:drink_less/pages/take_picture.dart';
import 'package:flutter/material.dart';

import 'package:drink_less/extra/footer.dart';
import 'package:drink_less/extra/header.dart';

class PicturePage extends StatefulWidget {
  const PicturePage({super.key});

  @override
  State<PicturePage> createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {

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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/background/background.png', fit: BoxFit.cover),
          ),
          Text("Take picture"),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await takePicture(context),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
