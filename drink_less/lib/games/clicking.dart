import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Shape { rect, circle}

class ClickBlock {
  double x;
  double y;
  double size;
  double change;
  Color color;
  Shape shape;

  /* destruction only */
  double dt = 0;

  bool _insideTriangle(Offset tri, Offset click, double size) {
    final double height = (size * sqrt(3)) / 2.0;

    final Offset p1 = Offset(tri.dx, tri.dy);
    final Offset p2 = Offset(p1.dx + size, p1.dy);
    final Offset p3 = Offset(p1.dx + size / 2, p1.dy - height);

    double sign(Offset p1, Offset p2, Offset p3) {
      return (p1.dx - p3.dx) * (p2.dy - p3.dy) - (p2.dx - p3.dx) * (p1.dy - p3.dy);
    }

    double d1 = sign(click, p1, p2);
    double d2 = sign(click, p2, p3);
    double d3 = sign(click, p3, p1);

    bool hasNegative = (d1 < 0) || (d2 < 0) || (d3 < 0);
    bool hasPositive = (d1 > 0) || (d2 > 0) || (d3 > 0);

    return !(hasNegative && hasPositive); // Point is inside if all signs are the same
  }


  bool isClicked(Offset o) {
    switch (shape) {
      case Shape.rect:
        return o.dx > x && o.dy > y && o.dx < x + size && o.dy < y + size;
      case Shape.circle:
        final ds = (o.dx - x) * (o.dx - x) + (o.dy - y) * (o.dy - y);
        return ds <= size * size;
      // case Shape.triangle:
      //   return _insideTriangle(Offset(x, y), o, size);
    }
  }

  ClickBlock({
    required this.x,
    required this.y,
    required this.change,
    required this.color,
    required this.size,
    required this.shape,
  });
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