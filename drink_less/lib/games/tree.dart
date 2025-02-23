import 'package:flutter/material.dart';
import 'dart:math';

class TreeWidget extends StatelessWidget {
  final int n; // Number of leaves

  const TreeWidget({super.key, required this.n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: CustomPaint(
        size: Size.infinite,
        painter: TreePainter(n, true),
        foregroundPainter: TreePainter(n, false),
      ),
    );
  }
}

class TreePainter extends CustomPainter {
  final int n;
  final bool blur;

  TreePainter(this.n, this.blur);

  Color getColor(int days) {
    final rand = Random();
    return Color.fromRGBO(0, (rand.nextDouble() * 60 + 150).toInt(), 0, 1);

    // if (n == 1) {
    //   return Color.fromRGBO(
    //     (rand.nextDouble() * 60 + 150).toInt(),
    //     (rand.nextDouble() * 60 + 150).toInt(),
    //     (rand.nextDouble() * 60 + 150).toInt(),
    //     1,
    //   );
    // }

    // if (n > 30) {
    //   return Color.fromRGBO(0, (rand.nextDouble() * 60 + 150).toInt(), 0, 1);
    // }

    // return Color.fromRGBO(255, 255, rand.nextInt(255), 1);
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
        Paint()
          ..color = getColor(n)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur ? 10.0 : 2.0),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
