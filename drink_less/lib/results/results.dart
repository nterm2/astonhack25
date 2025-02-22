import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data - need to read from json file
    final results = Results(
      baseline: 60,
      todayReactionResult: 40.0,
      todayMemoryResult: 50.0,
      todayPsychometricResult: 90.0,
      todayAIResult: 70.0,
      day7: 70.0,
      day6: 70.0,
      day5: 70.0,
      day4: 30.0,
      day3: 30.0,
      day2: 30.0,
      day1: 50.0,
      reactionAverage: 54.0,
      memoryAverage: 54.0,
      psychometricAverage: 54.0,
      AIAverage: 54.0,
    );

    // Radar chart data
    final List<String> categories = ['Reaction', 'Memory', 'Shape', 'AI Detection'];
    final List<double> baselineValues = [
      results.baseline.toDouble(),
      results.baseline.toDouble(),
      results.baseline.toDouble(),
      results.baseline.toDouble()
    ];
    final List<double> todayValues = [
      results.todayReactionResult,
      results.todayMemoryResult,
      results.todayPsychometricResult,
      results.todayAIResult,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Baseline: ${results.baseline}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Today\'s Reaction Result: ${results.todayReactionResult}', style: const TextStyle(fontSize: 18)),
            Text('Today\'s Memory Result: ${results.todayMemoryResult}', style: const TextStyle(fontSize: 18)),
            Text('Today\'s Psychometric Result: ${results.todayPsychometricResult}', style: const TextStyle(fontSize: 18)),
            Text('Today\'s AI Result: ${results.todayAIResult}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Radar Chart:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            Expanded(
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      dataEntries: baselineValues.map((value) => RadarEntry(value: value)).toList(),
                      borderColor: Colors.blue,
                      fillColor: Colors.blue.withOpacity(0.2),
                      borderWidth: 2,
                      entryRadius: 4, // Add points on the blue line
                    ),
                    RadarDataSet(
                      dataEntries: todayValues.map((value) => RadarEntry(value: value)).toList(),
                      borderColor: Colors.green,
                      fillColor: Colors.green.withOpacity(0.2),
                      borderWidth: 2,
                      entryRadius: 4, // Add points on the green line
                    ),
                  ],
                  radarBorderData: BorderSide.none, // Remove black border
                  titlePositionPercentageOffset: 0.2, // Adjust title positions further out
                  getTitle: (index, _) {
                    return RadarChartTitle(
                      text: categories[index], // Use category names as titles
                    );
                  },
                  tickCount: 5, // Number of rings in the radar chart
                  ticksTextStyle: TextStyle(color: Colors.black, fontSize: 12), // Tick label styling
                  tickBorderData: BorderSide(color: Colors.grey.withOpacity(0.5)), // Style for ticks
                  gridBorderData: BorderSide(color: Colors.grey.withOpacity(0.5)), // Style for grid lines
                  radarBackgroundColor: Colors.transparent, // Transparent background
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Results class with individual day variables
class Results {
  final int baseline;
  final double todayReactionResult;
  final double todayMemoryResult;
  final double todayPsychometricResult;
  final double todayAIResult;
  final double day7;
  final double day6;
  final double day5;
  final double day4;
  final double day3;
  final double day2;
  final double day1;
  final double reactionAverage;
  final double memoryAverage;
  final double psychometricAverage;
  final double AIAverage;

  Results({
    required this.baseline,
    required this.todayReactionResult,
    required this.todayMemoryResult,
    required this.todayPsychometricResult,
    required this.todayAIResult,
    required this.day7,
    required this.day6,
    required this.day5,
    required this.day4,
    required this.day3,
    required this.day2,
    required this.day1,
    required this.reactionAverage,
    required this.memoryAverage,
    required this.psychometricAverage,
    required this.AIAverage,
  });
}




    /*
    results.baseline
    results.todayReactionResult
    results.todayMemoryResult
    results.todayPsychometricResult
    results.todayAIResult
    */

    /*
    results.day7
    results.day6
    results.day5
    results.day4
    results.day3
    results.day2
    results.day1
    */

    /*
    results.reactionAverage
    results.memoryAverage
    results.psychometricAverage
    results.AIAverage
    */


/*
RadarChart(
  RadarChartData(
    dataSets: [
      RadarDataSet(
        dataEntries: baselineValues.map((value) => RadarEntry(value: value)).toList(),
        borderColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.2),
        borderWidth: 2,
      ),
      RadarDataSet(
        dataEntries: todayValues.map((value) => RadarEntry(value: value)).toList(),
        borderColor: Colors.green,
        fillColor: Colors.green.withOpacity(0.2),
        borderWidth: 2,
      ),
    ],
    radarBorderData: BorderSide.none, // Remove black border
    titlePositionPercentageOffset: 0.2, // Adjust title positions further out
    getTitle: (index, _) {
      return RadarChartTitle(
        text: categories[index], // Use category names as titles
      );
    },
    tickCount: 5, // Number of rings in the radar chart
    tickBorderData: BorderSide(color: Colors.grey.withOpacity(0.5)), // Style for ticks
    gridBorderData: BorderSide(color: Colors.grey.withOpacity(0.5)), // Style for grid lines
  ),
),
*/