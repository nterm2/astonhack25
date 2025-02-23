import 'package:drink_less/games/clicking.dart';
import 'package:drink_less/games/shape_rotation.dart';
import 'package:drink_less/games/memory_match_game.dart';
import 'package:drink_less/pages/clicking_page.dart';
import 'package:drink_less/pages/start_page.dart';
import 'package:drink_less/results/results.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
<<<<<<< HEAD
      home: Scaffold(
        body: MemoryMatchGame(),
        //body: StartTestPage(),

      ),
=======
      home: StartTestPage(),
>>>>>>> 54bd9d25a05228a29ab2df0549375d1ab1add0c1
    );
  }
}
