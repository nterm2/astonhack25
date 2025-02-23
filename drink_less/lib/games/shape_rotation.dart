import 'package:drink_less/pages/start_page.dart';
import 'package:drink_less/results/results.dart';
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
  int numCorrectAnswers = 0;
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
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1), // Light green transparent background
              borderRadius: BorderRadius.circular(12), // Rounded corners
              border: Border.all(
                color: Colors.green.shade800, // Dark green outline
                width: 3, // Outline width
              ),
            ),
            padding: const EdgeInsets.all(16), // Padding inside the container
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content only
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to Shape Rotation!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Highlighted green text
                  ),
                ),
                const SizedBox(height: 16), // Spacing
                const Text(
                  'Choose the correct rotated shape to advance to the next question.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87, // Softer black for text
                    height: 1.5, // Line height for better readability
                  ),
                ),
                const SizedBox(height: 16), // Spacing before the button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      setState(() {
                        gameStarted = true; // Game starts after modal is dismissed
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Green background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Curved edges
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ), // Button padding
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // White text
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final sar = SAR(widget.questionNumber);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(  
        children: [
          // Background image in the Stack
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/background.png', 
              fit: BoxFit.cover, 
            ),
          ),
          // Content in the Column
          gameStarted
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
                                        if (c.$1 == sar.answer) numCorrectAnswers++;
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              if (widget.questionNumber < 5) {
                                              return ShapeRotation(questionNumber: widget.questionNumber + 1);
                                            } else {
                                              // Isaac
                                              double shape_rotation_result = (numCorrectAnswers / 5) * 100;
                                              return ResultsPage();
                                            }
                                            }
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
                  child: CircularProgressIndicator(), // Loader while waiting
                ),
        ],
      ),

      bottomNavigationBar: const Footer(),
    );
  }
}
