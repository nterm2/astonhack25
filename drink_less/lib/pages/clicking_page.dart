import 'package:drink_less/games/clicking.dart';
import 'package:drink_less/games/memory_match_game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClickingPage extends StatefulWidget {
  const ClickingPage({super.key});

  @override
  State<ClickingPage> createState() => _ClickingPageState();
}

class _ClickingPageState extends State<ClickingPage> {
  ClickingState cs = ClickingState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          cs.onClick(details.localPosition);
        },
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(seconds: 100),
          builder: (context2, value, child) {
            if (cs.update(MediaQuery.of(context2).size, value)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MemoryMatchGame()),
                );
              });
            }
            return CustomPaint(size: Size.infinite, painter: Clicking(cs: cs));
          },
        ),
      ),
    );
  }
}
