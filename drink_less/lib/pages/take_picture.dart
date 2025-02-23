import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:drink_less/pages/clicking_page.dart';
import 'package:flutter/material.dart';

import 'package:drink_less/extra/footer.dart';
import 'package:drink_less/extra/header.dart';

import 'package:drink_less/games/clicking.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartDialog();
    });
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

    void _showStartDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents accidental dismissal
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Welcome to the Picture Test!'),
          content: const Text(
            "In this test, you'll have to take a picture of yourself, which we will use our pre-trained machine learning models to determine your intoxication levels. Please make sure to include the entirety of your face in this picture, and ensure there are no additional distractions. Good luck.",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                   // Start game after dialog is dismissed
                });
              },
              child: const Text('Start'),
            ),
          ],
        );
      },
    );
  }

    void _showEndDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents accidental dismissal
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Finished The Picture Test.'),
          content: const Text(
            "Say Cheese! Let's push on forward to the Clicking Test.",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ClickingGame()),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.

      /* HERE IS WHERE IT WONT WORK */
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/background/background.png', fit: BoxFit.cover),
          ),
          //Text("Please take a photo of your whole face!"),
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => DisplayPictureScreen(
                      // Pass the automatically generated path to
                      // the DisplayPictureScreen widget.
                      imagePath: image.path,
                    ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: FutureBuilder(
        future: Future.delayed(Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => ClickingPage()));
            });
          }
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset('assets/images/background/background.png', fit: BoxFit.cover),
              ),
              Column(
                children: [
                  Text("Sending the image"),
                  Image.file(File(imagePath)),
                ],
              ),
              Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
