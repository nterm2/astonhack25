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
      home: Scaffold(

<<<<<<< HEAD
        body: StartTestPage(),
        //body: ClickingGame(),
=======
        //body: ShapeRotation(questionNumber: 1,),
<<<<<<< HEAD
        //body: StartTestPage(),
        body: ResultsPage(),
=======
        body: StartTestPage(),
>>>>>>> 70fbebc5112c1b4a31e0026865099835b712e33a
>>>>>>> 4aec3fc3bf406324d721e45d27af1b72145bcce0
      ),
    );
  }
}