import 'package:drink_less/games/shape_rotation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import 'package:drink_less/extra/footer.dart';
import 'package:drink_less/extra/header.dart';

class MemoryMatchGame extends StatelessWidget {
  const MemoryMatchGame({super.key});

  @override
  Widget build(BuildContext context) {
    return GameScreen();
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

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
  int timeLeft = 30;
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
          content: Text('Try to match all pairs before time runs out. Good luck!'),
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

  void _startGame() {
    setState(() {
      gameStarted = true;
      showAllTiles = true;
    });

    Future.delayed(Duration(seconds: 2), () {
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
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    timer?.cancel();
    gameOver = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ShapeRotation()),
    );
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
          Future.delayed(Duration(milliseconds: 300), () {
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
          _endGame();
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


class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Over')),
      body: Center(
        child: Text(
          'Neil is cool',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
