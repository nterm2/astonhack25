import 'package:drink_less/games/clicking.dart';
import 'package:drink_less/games/memory_match_game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        return AlertDialog(
          title: const Text('Welcome to the Clicking Test!'),
          content: const Text(
            'This test measures your reaction time. Twenty objects will fall from the sky - your aim is to catch as many of these objects as possible. Failing to do so will decrease your score. Good luck!',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  gameStarted = true; // Start game after dialog is dismissed
                });
              },
              child: const Text('Start'),
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
    );
  }
}
