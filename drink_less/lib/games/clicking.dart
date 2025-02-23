import 'dart:math';
import 'package:flutter/material.dart';

import 'package:drink_less/extra/footer.dart';
import 'package:drink_less/extra/header.dart';

enum Shape { rect, circle }

class ClickBlock {
  double x;
  double y;
  double size;
  double change;
  Color color;
  Shape shape;

  ClickBlock({
    required this.x,
    required this.y,
    required this.change,
    required this.color,
    required this.size,
    required this.shape,
  });

  bool isClicked(Offset o) {
    switch (shape) {
      case Shape.rect:
        return o.dx > x && o.dy > y && o.dx < x + size && o.dy < y + size;
      case Shape.circle:
        final ds = (o.dx - x) * (o.dx - x) + (o.dy - y) * (o.dy - y);
        return ds <= size * size;
    }
  }
}

class ClickingState {
  int count = 0;
  int destroyed = 0;
  double odt = 0;
  double deltaT = 0;
  List<ClickBlock> points = [];
  List<ClickBlock> correct = [];

  void onClick(Offset clickLocation) {
    for (int i = 0; i < points.length; ++i) {
      if (!points[i].isClicked(clickLocation)) continue;

      correct.add(points[i]);
      points.removeAt(i);
      --i;
      ++destroyed;
    }
  }

  bool update(Size size, double dt) {
    deltaT = dt - odt;
    odt = dt;

    for (int i = 0; i < points.length; ++i) {
      points[i].y += deltaT * points[i].change;
      if (points[i].y - points[i].change > size.height) {
        points.removeAt(i);
        --i;
        ++destroyed;
      }
    }

    final last = points.lastOrNull;
    if (last == null || last.y > size.height / 4 && Random().nextBool()) {
      _addNewBlock(size);
    }
    return count >= 20;
  }

  void _addNewBlock(Size size) {
    final rand = Random();
    final sz = 50.0;
    final shape = Shape.values[rand.nextInt(Shape.values.length)];
    points.add(
      ClickBlock(
        x: rand.nextDouble() * (size.width - 100 - sz) + sz,
        y: -sz,
        change: rand.nextDouble() * 20000 + 20000,
        color: Color.fromRGBO(
          rand.nextInt(256),
          rand.nextInt(256),
          rand.nextInt(256),
          1.0,
        ),
        size: shape == Shape.circle ? sz / 2 : sz,
        shape: shape,
      ),
    );
    ++count;
  }
}

class Clicking extends CustomPainter {
  final ClickingState cs;

  Clicking({required this.cs});

  void drawShape({required Canvas canvas, required ClickBlock cb}) {
    final paint = Paint()..color = cb.color;
    switch (cb.shape) {
      case Shape.circle:
        canvas.drawCircle(Offset(cb.x, cb.y), cb.size, paint);
        break;
      case Shape.rect:
        canvas.drawRect(Rect.fromLTWH(cb.x, cb.y, cb.size, cb.size), paint);
        break;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in cs.points) {
      drawShape(canvas: canvas, cb: p);
    }

    for (var p in cs.correct) {
      p.size -= cs.deltaT * 10000;
      p.y += cs.deltaT * p.change;
      if (p.size > 0) {
        drawShape(canvas: canvas, cb: p);
        continue;
      }

      cs.correct.remove(p);
    }
  }

  @override
  bool shouldRepaint(_) {
    return true;
  }
}

class ClickingGame extends StatefulWidget {
  const ClickingGame({super.key});

  @override
  _ClickingGameState createState() => _ClickingGameState();
}

class _ClickingGameState extends State<ClickingGame> {
  bool gameStarted = false;
  ClickingState cs = ClickingState();

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
      barrierDismissible: false, // Prevents accidental dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Welcome to the Clicking Game!'),
          content: Text('Click on the shapes as they appear to score points!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                setState(() {
                  gameStarted = true; // Start game after dismissing dialog
                });
              },
              child: Text('Start'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: gameStarted
          ? GestureDetector(
        onTapDown: (TapDownDetails details) {
          setState(() {
            cs.onClick(details.globalPosition);
          });
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: Clicking(cs: cs),
        ),
      )
          : Center(
        child: CircularProgressIndicator(), // Shows a spinner until modal is dismissed
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
