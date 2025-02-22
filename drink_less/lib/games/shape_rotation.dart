import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class ShapeRotation extends StatefulWidget {
  const ShapeRotation({super.key});

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
        options = ["A", "B", "D"]
            .map((n) => Image.asset("assets/images/q$qn/$n.png"))
            .toList();

  List<(Image, String)> getAnswers() {
    var lst = List<Image>.from(options);
    lst.add(answer);
    int codeUnit = "A".codeUnitAt(0);
    return lst.map((img) => (img, String.fromCharCode(codeUnit++))).toList();
  }
}

class _ShapeRotationState extends State<ShapeRotation> {
  bool showAll = true; // Initially show all cards

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showAll = false; // Hide the cards after 2 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final sar = SAR(1);
    return Scaffold(
      appBar: AppBar(title: Text("Shapes and Rotation")),
      body: Column(
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
                        onPressed: showAll
                            ? null // Disable interaction while cards are visible
                            : () {
                          if (c.$1 == sar.answer) {
                            print("RIGHT ANSWER");
                          }
                        },
                        child: showAll ? c.$1 : Icon(Icons.help), // Show image or placeholder
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
      ),
    );
  }
}
