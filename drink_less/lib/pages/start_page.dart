import 'package:camera/camera.dart';
import 'package:drink_less/pages/picture_page.dart';
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/background/background.png', fit: BoxFit.cover),
          ),
          
          const SizedBox(height: 10),
          // The container now only wraps the text
          Align(
            alignment: Alignment.topCenter, // Positioning it at the top
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1), // Light calm green background (transparent)
                borderRadius: BorderRadius.circular(12), // Rounded corners
                border: Border.all(
                  color: Colors.green.shade800, // Dark strong green outline
                  width: 3, // Outline width
                ),
              ),
              padding: const EdgeInsets.all(16), // Padding inside the container
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensures the column takes only as much space as needed
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16), // Space between the top and the text
                  const Text(
                    '''Welcome Jonathan! This is a supportive space designed to help you grow!
                    \nWe understand that making changes in habits can be challenging, and we’re here to guide you every step of the way.
                    \nWe’re excited to support your journey toward a healthier, more balanced life.''',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          
          // The button is centered at the bottom
          Center(
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
        ],
      ),
      bottomNavigationBar: const Footer(),
    );

  }
  
}
