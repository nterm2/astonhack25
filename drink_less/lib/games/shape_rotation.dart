import 'package:drink_less/pages/start_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:drink_less/extra/footer.dart';
import 'package:drink_less/extra/header.dart';

class ShapeRotation extends StatefulWidget {
  final int questionNumber;

  const ShapeRotation({super.key, this.questionNumber = 1});

  @override
  State<ShapeRotation> createState() => _ShapeRotationState();
}

class SAR {
  final Image question;
  final Image answer;
  final List<Image> options;

  SAR(int qn)
      : question = Image.asset("assets/images/q$qn/Q.png"),
        answer = Image.asset("assets/images/q$qn/Answer.png"),
        options =
        ["B", "C", "D"].map((n) => Image.asset("assets/images/q$qn/$n.png")).toList();

  List<(Image, String)> getAnswers() {
    var lst = List<Image>.from(options);
    lst.add(answer);
    int codeUnit = "A".codeUnitAt(0);
    return lst.map((img) => (img, String.fromCharCode(codeUnit++))).toList();
  }
}

class _ShapeRotationState extends State<ShapeRotation> {
  bool gameStarted = false; // Ensures game starts only after modal dismissal

  @override
  void initState() {
    super.initState();

    // Show the modal only for the first question
    if (widget.questionNumber == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showStartDialog();
      });
    } else {
      gameStarted = true; // Automatically start the game for subsequent questions
    }
  }

  void _showStartDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents accidental dismissal
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Welcome to Shape Rotation!'),
          content: Text(
            'Choose the correct rotated shape to advance to the next question.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  gameStarted = true; // Game starts after modal is dismissed
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sar = SAR(widget.questionNumber);

    return Scaffold(
      appBar: CustomAppBar(),
      body: gameStarted
          ? Column(
        children: [
          Padding(padding: EdgeInsets.all(20), child: sar.question),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: sar
                .getAnswers()
                .map(
                  (c) => Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (c.$1 == sar.answer) print("RIGHT ANSWER");
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => widget.questionNumber < 5
                                  ? ShapeRotation(questionNumber: widget.questionNumber + 1)
                                  : StartTestPage(),
                            ),
                          );
                        },
                        child: c.$1,
                      ),
                      Text(c.$2),
                    ],
                  ),
                ),
              ),
            )
                .toList(),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(), // Shows a loader until the modal is dismissed
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
