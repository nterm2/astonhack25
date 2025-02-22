import 'package:drink_less/pages/start_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

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
          [
            "B",
            "C",
            "D",
          ].map((n) => Image.asset("assets/images/q$qn/$n.png")).toList();

  List<(Image, String)> getAnswers() {
    var lst = List<Image>.from(options);
    lst.add(answer);
    int codeUnit = "A".codeUnitAt(0);
    return lst.map((img) => (img, String.fromCharCode(codeUnit++))).toList();
  }
}

class _ShapeRotationState extends State<ShapeRotation> {
  @override
  Widget build(BuildContext context) {
    final sar = SAR(widget.questionNumber);
    return Scaffold(
      appBar: AppBar(title: Text("Shapes and rotation")),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(20), child: sar.question),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                sar
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
                                      builder:
                                          (context) =>
                                              widget.questionNumber < 5
                                                  ? ShapeRotation(
                                                    questionNumber:
                                                        widget.questionNumber +
                                                        1,
                                                  )
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
      ),
    );
  }
}
