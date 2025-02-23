import 'package:drink_less/games/shape_rotation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import 'package:drink_less/extra/footer.dart';
import 'package:drink_less/extra/header.dart';

class MemoryMatchGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameScreen();
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> icons = ['🍎', '🍌', '🍒', '🍇', '🥝', '🍍', '🍉', '🥑'];
  late List<String> tiles;
  late List<bool> revealed;
  int firstIndex = -1;
  int secondIndex = -1;
  int matchedPairs = 0;
  int attempts = 0;
  int timeLeft = 45;
  Timer? timer;
  bool gameOver = false;
  bool showAllTiles = true;
  bool gameStarted = false;
  bool isChecking = false; // Prevents excessive taps

  @override
  void initState() {
    super.initState();
    tiles = [...icons, ...icons];
    tiles.shuffle(Random());
    revealed = List.generate(16, (index) => false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartDialog();
    });
  }

  void _showStartDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Welcome to Memory Match!'),
          content: Text('In this test, you will be shown pairs of tiles. You will have 15 seconds to memorize the tiles’ locations and 30 seconds to match them correctly. Pay attention to detail and try to remember the positions of the tiles!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startGame();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

void _showEndDialog() {
  if (gameOver) return; // Prevents multiple dialogs

  gameOver = true; // Mark game as finished
  timer?.cancel(); // Stop the timer to prevent more updates

  Future.delayed(Duration(milliseconds: 100), () { // Small delay to prevent UI flicker
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Finished Memory Match Test.'),
          content: const Text(
            'Well done - memorising so much in such little time isn\'t an easy task. Let\'s move on to the Shape Rotation Test.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ShapeRotation()),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  });
}

  void _startGame() {
    setState(() {
      gameStarted = true;
      showAllTiles = true;
    });

    Future.delayed(Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          showAllTiles = false;
        });
      }
    });

    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          _showEndDialog();
        }
      });
    });
  }

  void tileTapped(int index) {
    if (!gameStarted || isChecking || revealed[index] || firstIndex == index || gameOver || showAllTiles) {
      return; // Prevent clicking when checking
    }

    setState(() {
      if (firstIndex == -1) {
        firstIndex = index;
      } else if (secondIndex == -1) {
        secondIndex = index;
        isChecking = true; // Lock interactions while checking
        attempts++;

        if (tiles[firstIndex] == tiles[secondIndex]) {
          revealed[firstIndex] = true;
          revealed[secondIndex] = true;
          matchedPairs++;
          Future.delayed(Duration(milliseconds: 450), () {
            if (mounted) {
              setState(() {
                firstIndex = -1;
                secondIndex = -1;
                isChecking = false;
              });
            }
          });
        } else {
          Future.delayed(Duration(seconds: 1), () {
            if (mounted) {
              setState(() {
                firstIndex = -1;
                secondIndex = -1;
                isChecking = false;
              });
            }
          });
        }

        if (matchedPairs == icons.length) {
          _showEndDialog();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Time Left: $timeLeft s', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: tiles.length,
              itemBuilder: (context, index) {
                bool isRevealed = revealed[index] || firstIndex == index || secondIndex == index;

                return GestureDetector(
                  onTap: () => tileTapped(index),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    transitionBuilder: (widget, animation) {
                      final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
                      return AnimatedBuilder(
                        animation: rotateAnim,
                        child: widget,
                        builder: (context, child) {
                          final isFlipped = rotateAnim.value >= pi / 2;
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(rotateAnim.value),
                            child: isFlipped ? Container() : child,
                          );
                        },
                      );
                    },
                    child: Container(
                      key: ValueKey(isRevealed),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        showAllTiles || isRevealed ? tiles[index] : '★',
                        style: TextStyle(fontSize: 32, color: Colors.green[700]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: const Footer(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
