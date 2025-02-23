import 'package:drink_less/games/clicking.dart';
import 'package:drink_less/games/memory_match_game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:drink_less/extra/footer.dart';
import 'package:drink_less/extra/header.dart';

class ClickingPage extends StatefulWidget {
  const ClickingPage({super.key});

  @override
  State<ClickingPage> createState() => _ClickingPageState();
}

class _ClickingPageState extends State<ClickingPage> {
  ClickingState cs = ClickingState();
  bool gameStarted = false;
  bool gameEnded = false; // Prevents multiple navigation calls

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartDialog();
    });
  }

  void _showStartDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents accidental dismissal
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1), // Light green transparent background
              borderRadius: BorderRadius.circular(12), // Rounded corners
              border: Border.all(
                color: Colors.green.shade800, // Dark green outline
                width: 3, // Outline width
              ),
            ),
            padding: const EdgeInsets.all(16), // Padding inside the container
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content only
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to the Clicking Test!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Highlighted green text
                  ),
                ),
                const SizedBox(height: 16), // Spacing
                const Text(
                  'This test measures your reaction time. Twenty objects will fall from the sky - your aim is to catch as many of these objects as possible. Failing to do so will decrease your score. Good luck!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87, // Softer black for text
                    height: 1.5, // Line height for better readability
                  ),
                ),
                const SizedBox(height: 16), // Spacing before the button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      setState(() {
                        gameStarted = true; // Start the game after dialog is dismissed
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Green background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ), // Padding for the button
                    ),
                    child: const Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // White text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          title: const Text('Finished The Clicking Test.'),
          content: const Text(
            'Congrats! Hopefully catching so many shapes wasn\'nt too energy consuming. We\'ll now go over towards the Memory Match Test - make sure you are on your A-Game!',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  gameStarted = true; // Start game after dialog is dismissed
                });
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _checkGameEnd(double value) {
    if (!gameEnded && cs.update(MediaQuery.of(context).size, value)) {
      setState(() {
        gameEnded = true; // Ensures navigation only happens once
      });

      Future.microtask(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MemoryMatchGame()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: GestureDetector(
        onTapDown: (details) {
          if (gameStarted) {
            cs.onClick(details.localPosition);
          }
        },
        child: gameStarted // Prevent animation before game starts
            ? TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 100),
                builder: (context2, value, child) {
                  _checkGameEnd(value);
                  return CustomPaint(
                    size: Size.infinite,
                    painter: Clicking(cs: cs),
                  );
                },
              )
            : Container(color: Colors.white), // Blank screen before game starts
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
