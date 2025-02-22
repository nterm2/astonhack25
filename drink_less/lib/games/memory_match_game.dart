import 'package:drink_less/games/shape_rotation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(MemoryMatchGame());
}

class MemoryMatchGame extends StatelessWidget {
  const MemoryMatchGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: GameScreen());
  }
}



class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  List<String> icons = ['🍎', '🍌', '🍒', '🍇', '🥝', '🍍', '🍉', '🥑'];
  late List<String> tiles;
  late List<bool> revealed;
  int firstIndex = -1;
  int secondIndex = -1;
  int matchedPairs = 0;
  int attempts = 0;
  int timeLeft = 30;
  late Timer timer;
  bool gameOver = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  // New variable to track if we are showing all tiles for memorization
  bool showAllTiles = true;

  @override
  void initState() {
    super.initState();
    tiles = [...icons, ...icons];
    tiles.shuffle(Random());
    revealed = List.generate(16, (index) => false);
    startTimer();

    // Initialize the animation controller for tile rotation
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 3.14,
    ).animate(_animationController);

    // Delay to show all tiles at the start
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        // After 2 seconds, hide the tiles and start the game
        showAllTiles = false;
      });
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          gameOver = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ShapeRotation()),
          );
        }
      });
    });
  }

  void tileTapped(int index) {
    if (revealed[index] || firstIndex == index || gameOver || showAllTiles) return;

    setState(() {
      if (firstIndex == -1) {
        firstIndex = index;
        _animationController.forward(); // Trigger rotation animation for the first tile
      } else {
        secondIndex = index;
        attempts++;
        _animationController.forward(); // Trigger rotation animation for the second tile
        if (tiles[firstIndex] == tiles[secondIndex]) {
          revealed[firstIndex] = true;
          revealed[secondIndex] = true;
          matchedPairs++;
          firstIndex = -1;
          secondIndex = -1;
        } else {
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              firstIndex = -1;
              secondIndex = -1;
            });
          });
        }
      }
    });
  }

  Widget mkChild(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        revealed[index] || firstIndex == index || secondIndex == index
            ? tiles[index]
            : '?',
        style: TextStyle(fontSize: 32, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double ratio = attempts == 0 ? 0.0 : matchedPairs / attempts;

    return Scaffold(
      appBar: AppBar(title: Text('Memory Match Game')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Time Left: $timeLeft s', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
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
                        showAllTiles || isRevealed
                            ? tiles[index]
                            : '★', // Show all tiles if showAllTiles is true
                        style: TextStyle(fontSize: 32, color: Colors.greenAccent[400]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _animationController.dispose(); // Dispose the animation controller
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
