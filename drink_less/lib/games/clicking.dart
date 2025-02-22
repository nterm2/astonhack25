import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Shape { rect, circle, triangle }

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
    final height = (size * sqrt(3)) / 2.0;

    final p1 = Offset(tri.dx, tri.dy);
    final p2 = Offset(p1.dx + size, p1.dy);
    final p3 = Offset(p1.dx + size / 2, p1.dy - height);

    // Calculate the area of the triangle p1p2p3
    double areaP1P2P3 = 0.5 * (-p2.dy * p3.dx + p1.dy * (-p2.dx + p3.dx) + p1.dx * (p2.dy - p3.dy) + p2.dx * p3.dy);

    // Calculate the areas of the sub-triangles clickp1p2, clickp2p3, and clickp3p1
    double areaClickP1P2 = 0.5 * (click.dy * (p1.dx - p2.dx) + click.dx * (p2.dy - p1.dy) + p1.dx * p2.dy - p1.dy * p2.dx);
    double areaClickP2P3 = 0.5 * (click.dy * (p2.dx - p3.dx) + click.dx * (p3.dy - p2.dy) + p2.dx * p3.dy - p2.dy * p3.dx);
    double areaClickP3P1 = 0.5 * (click.dy * (p3.dx - p1.dx) + click.dx * (p1.dy - p3.dy) + p3.dx * p1.dy - p3.dy * p1.dx);

    // Check if the click point is inside the triangle by comparing the areas
    return (areaP1P2P3 == areaClickP1P2 + areaClickP2P3 + areaClickP3P1);

  }

  bool isClicked(Offset o) {
    switch (shape) {
      case Shape.rect:
        return o.dx > x && o.dy > y && o.dx < x + size && o.dy < y + size;
      case Shape.circle:
        final ds = (o.dx - x) * (o.dx - x) + (o.dy - y) * (o.dy - y);
        return ds <= size * size;
      case Shape.triangle:
        return _insideTriangle(Offset(x, y), o, size);
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

class ClickingState {
  double odt = 0;
  List<ClickBlock> points = [];
  List<ClickBlock> correct = [];

  void onClick(Offset clickLocation) {
    for (int i = 0; i < points.length; ++i) {
      if (!points[i].isClicked(clickLocation)) continue;

      points[i].dt = odt;
      correct.add(points[i]);
      points.removeAt(i);
      --i;
    }
  }

  bool update(Size size, double dt) {
    final deltaT = dt - odt;
    odt = dt;

    for (var p in points) {
      p.y += deltaT * p.change;
    }

    final last = points.lastOrNull;
    if (last == null || last.y > size.height / 4 && Random().nextBool()) {
      _addNewBlock(size);
    }
    return true;
  }

  void _addNewBlock(Size size) {
    final rand = Random();
    // final sz = (rand.nextInt(20) + 40).toDouble();
    final sz = (50).toDouble();
    final shape = Shape.values.elementAt(rand.nextInt(Shape.values.length));
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
        shape: shape
      ),
    );
  }

  bool hasFailed(Size size) {
    final res = points.firstOrNull;
    if (res == null) return true;
    return res.y > size.height;
  }
}

class Clicking extends CustomPainter {
  final ClickingState cs;

  Clicking({required this.cs});

  void _drawTriangle({required Canvas canvas, required ClickBlock cb, required Paint paint}) {
    final height = (cb.size * sqrt(3)) / 2.0;

    final p1 = Offset(cb.x, cb.y);
    final p2 = Offset(p1.dx + cb.size, p1.dy);
    final p3 = Offset(p1.dx + cb.size / 2, p1.dy - height);

    Path path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  void drawShape({required Canvas canvas, required ClickBlock cb}) {
    final paint = Paint()..color = cb.color;
    switch (cb.shape) {
      case Shape.circle:
        canvas.drawCircle(Offset(cb.x, cb.y), cb.size, paint);
        break;

      case Shape.triangle:
        _drawTriangle(canvas: canvas, cb: cb, paint: paint);
        break;

      case Shape.rect:
      canvas.drawRect(Rect.fromLTWH(cb.x, cb.y, cb.size, cb.size), paint);
        break;
    }
  }

  double animate_destruct(double sz) {
    return sz * sz * exp(-0.5 * sz);
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in cs.points) {
      drawShape(canvas: canvas, cb: p);
    }

    for (var p in cs.correct) {
      drawShape(canvas: canvas, cb: p..size = p.size * animate_destruct((cs.odt - p.dt) * 0.01));
    }
  }

  @override
  bool shouldRepaint(_) {
    return true;
  }
}
