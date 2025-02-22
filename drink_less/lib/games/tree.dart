import 'package:flutter/material.dart';
import 'dart:math';

class TreeWidget extends StatelessWidget {
  final int n; // Number of leaves

  TreeWidget({required this.n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: CustomPaint(
            size: Size.infinite,
            painter: TreePainter(10),
      ),
    );
  }
}

class TreePainter extends CustomPainter {
  final int n;

  TreePainter(this.n);

  Color getColor(int days) {
    final rand = Random();
    if (n == 1) {
      return Color.fromRGBO(
        (rand.nextDouble() * 60 + 150).toInt(),
        (rand.nextDouble() * 60 + 150).toInt(),
        (rand.nextDouble() * 60 + 150).toInt(),
        1,
      );
    }

    if (n > 30) {
      return Color.fromRGBO(0, (rand.nextDouble() * 60 + 150).toInt(), 0, 1);
    }

    return Color.fromRGBO(255, 255, rand.nextInt(255), 1);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rand = Random();
    for (int i = 0; i < n; ++i) {
      final sz = rand.nextDouble() * 10;
      canvas.drawCircle(
        Offset(
          rand.nextDouble() * (size.width - 2 * sz) + sz,
          rand.nextDouble() * (size.height - 2 * sz) + sz,
        ),
        sz,
        Paint()..color = getColor(n),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
