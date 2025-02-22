import 'package:flutter/material.dart';
import 'dart:math';

class TreeWidget extends StatelessWidget {
  final int n; // Number of leaves

  TreeWidget({required this.n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 1, end: 100),
        duration: Duration(seconds: 60),
        builder: (context, value, child) {
          return CustomPaint(
            size: Size.infinite,
            painter: TreePainter(50 * value.toInt()),
          );
        },
      ),
    );
  }
}

class TreePainter extends CustomPainter {
  final int n;


  TreePainter(this.n);

  Offset getRandomPointInTriangle(Offset A, Offset B, Offset C) {
    // Generate two random numbers between 0 and 1
    double r1 = Random().nextDouble();
    double r2 = Random().nextDouble();

    // Barycentric coordinates
    double lambda1 = 1 - sqrt(r1);
    double lambda2 = sqrt(r1) * (1 - r2);
    double lambda3 = sqrt(r1) * r2;

    // Calculate the random point using the barycentric coordinates
    double x = lambda1 * A.dx + lambda2 * B.dx + lambda3 * C.dx;
    double y = lambda1 * A.dy + lambda2 * B.dy + lambda3 * C.dy;

    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final height = n / 2;
    final width = n / 4;
    final centre = size.width / 2;
    final tWidth = width / 4;

    final t1 = Offset(centre, 0);
    final t2 = Offset(centre - width, height);
    final t3 = Offset(centre + width, height);

    final tPath =
        Path()
          ..moveTo(t1.dx, t1.dy)
          ..lineTo(t2.dx, t2.dy)
          ..lineTo(t3.dx, t3.dy)
          ..close();

    final leaves =
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.fill;

    final trunk =
        Paint()
          ..color = Colors.brown
          ..style = PaintingStyle.fill;

    canvas.drawPath(tPath, leaves);
    canvas.drawRect(
      Rect.fromLTWH(centre - tWidth, height, tWidth * 2, height / 4),
      trunk,
    );

    final rand = Random();
    for (int i = 0; i < n / 50; ++i) {
      canvas.drawCircle(
        getRandomPointInTriangle(t1, t2, t3),
        n.toDouble() / 50,
        Paint()..color = Color.fromRGBO(0, rand.nextInt(200) + 56, 0, 1),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
