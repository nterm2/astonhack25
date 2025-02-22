import 'package:drink_less/games/clicking.dart';
import 'package:drink_less/games/memory_match_game.dart';
import 'package:drink_less/games/shape_rotation.dart';
import 'package:drink_less/games/tree.dart';
import 'package:drink_less/pages/clicking_page.dart';
import 'package:drink_less/pages/picture_page.dart';
import 'package:drink_less/pages/start_page.dart';
import 'package:flutter/foundation.dart';
import 'package:drink_less/results/results.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StartTestPage(),
    );
  }
}