import 'package:drink_less/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'package:drink_less/pages/tts_page.dart' as tts;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(tts.MyApp());
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
      home: StartTestPage(),
    );
  }
}
