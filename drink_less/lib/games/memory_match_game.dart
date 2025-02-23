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

  bool memorizationPhase = true; // Tracks whether the memorization phase is active

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
                  'Memory Match Test',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Highlighted green text
                  ),
                ),
                const SizedBox(height: 16), // Spacing
                const Text(
                  'In this test, you will be presented with pairs of tiles for 15 seconds to memorise their locations. Following this, you’ll have 30 seconds to match the tiles correctly. This exercise assesses your memory and attention to detail, helping you better understand your cognitive function and how it may be impacted. Take your time, and remember, there’s no rush—just focus on doing your best.',
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
                      Navigator.of(context).pop();
                      _startGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Green background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Curved edges
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ), // Button padding
                    ),
                    child: const Text(
                      'Start',
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
          ),
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
                  'Finished Memory Match Test.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Highlighted green text
                  ),
                ),
                const SizedBox(height: 16), // Spacing
                const Text(
                  'Well done - memorising so much in such little time isn\'t an easy task. Let\'s move on to the Shape Rotation Test.',
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
                      timer?.cancel();
                      gameOver = true;
                      // ISAAC
                      double ratio_correctly_matched = (matchedPairs / attempts) * 100;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ShapeRotation()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Green background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Curved edges
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ), // Button padding
                    ),
                    child: const Text(
                      'Continue',
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
          ),
        );
      },
    );
  });
}


void _startGame() {
  setState(() {
    gameStarted = true;
    showAllTiles = true;
    memorizationPhase = true; // Start with memorization phase
    timeLeft = 45; // Total time including memorization
  });

  Future.delayed(Duration(seconds: 15), () {
    if (mounted) {
      setState(() {
        showAllTiles = false;
        memorizationPhase = false; // End memorization phase
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
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/background.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Content inside a Column
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              
              // Your Container with Time Left
              Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memorizationPhase 
                        ? 'Memorise: ${timeLeft - 30} s' 
                        : 'Time Left: $timeLeft s',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              
              // GridView for tiles
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
