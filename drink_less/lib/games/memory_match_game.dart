import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(MemoryMatchGame());
}

class MemoryMatchGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
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
  int timeLeft = 30;
  late Timer timer;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    tiles = [...icons, ...icons];
    tiles.shuffle(Random());
    revealed = List.generate(16, (index) => false);
    startTimer();
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
            MaterialPageRoute(builder: (context) => GameOverScreen()),
          );
        }
      });
    });
  }

  void tileTapped(int index) {
    if (revealed[index] || firstIndex == index || gameOver) return;
    setState(() {
      if (firstIndex == -1) {
        firstIndex = index;
      } else {
        secondIndex = index;
        attempts++;
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

  @override
  Widget build(BuildContext context) {
    double ratio = attempts == 0 ? 0.0 : matchedPairs / attempts;
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Match Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Time Left: $timeLeft s', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          Text('Ratio: ${ratio.toStringAsFixed(2)}', style: TextStyle(fontSize: 20)),
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
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isRevealed ? tiles[index] : '?',
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },

            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                tiles.shuffle(Random());
                revealed = List.generate(16, (index) => false);
                firstIndex = -1;
                secondIndex = -1;
                matchedPairs = 0;
                attempts = 0;
                timeLeft = 30;
                gameOver = false;
                timer.cancel();
                startTimer();
              });
            },
            child: Text('Restart'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

class GameOverScreen extends StatelessWidget {
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