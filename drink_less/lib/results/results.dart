import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:drink_less/pages/start_page.dart';

import 'package:drink_less/extra/footer.dart';
import 'package:drink_less/extra/header.dart';

import 'package:drink_less/global.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data - need to read from json file
    final results = Results(
      baseline: 55,
      todayReactionResult: 78.0,
      todayMemoryResult: 81.0,
      todayPsychometricResult: 67.0,
      todayAIResult: 75.0,
      day7: 61.0,
      day6: 64.0,
      day5: 59.0,
      day4: 53.0,
      day3: 49.0,
      day2: 42,
      day1: 35.0,
      reactionAverage: 64.0,
      memoryAverage: 73.0,
      psychometricAverage: 68.0,
      AIAverage: 81.0,
    );

    // Radar chart data
    final List<String> categories = [
      'Reaction',
      'Match',
      'Shape Rotation',
      'Face',
    ];
    final List<double> baselineValues = [
      results.baseline.toDouble(),
      results.baseline.toDouble(),
      results.baseline.toDouble(),
      results.baseline.toDouble(),
    ];
    final List<double> todayValues = [
      results.todayReactionResult,
      results.todayMemoryResult,
      results.todayPsychometricResult,
      results.todayAIResult,
    ];

    // Line chart data
    final List<FlSpot> lineChartPoints = [
      FlSpot(1, results.day1),
      FlSpot(2, results.day2),
      FlSpot(3, results.day3),
      FlSpot(4, results.day4),
      FlSpot(5, results.day5),
      FlSpot(6, results.day6),
      FlSpot(7, results.day7),
    ];

    return Scaffold(
      appBar: CustomAppBar(),

      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/background.png',
              fit: BoxFit.cover, // Make sure the image covers the entire screen
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 0.0,
              top: 0.0, // Prevent padding above
            ),
            child: SingleChildScrollView(
              // Wrap Column with SingleChildScrollView
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      // Light calm green background (transparent)
                      borderRadius: BorderRadius.circular(12),
                      // Rounded corners
                      border: Border.all(
                        color: Colors.green.shade800,
                        // Dark strong green outline
                        width: 3, // Outline width
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    // Padding inside the container
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '''Tracking your journey is the first step toward change. Every step you take is progress, and each small victory brings you closer to your goals.
                          \nKeep moving forward—you're making incredible strides toward the change you deserve.''',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Today\'s Performance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // radar chart
                  SizedBox(
                    height: 300, // Set a fixed height for charts
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: RadarChart(
                        duration: Duration(seconds: 1),
                        curve: Curves.easeIn,
                        RadarChartData(
                          dataSets: [
                            RadarDataSet(
                              dataEntries:
                                  baselineValues
                                      .map((value) => RadarEntry(value: value))
                                      .toList(),
                              borderColor: Colors.blue,
                              fillColor: Colors.blue.withOpacity(0.2),
                              borderWidth: 2,
                              entryRadius: 4, // Add points on the blue line
                            ),
                            RadarDataSet(
                              dataEntries:
                                  todayValues
                                      .map((value) => RadarEntry(value: value))
                                      .toList(),
                              borderColor: Colors.red,
                              fillColor: Colors.red.withOpacity(0.2),
                              borderWidth: 2,
                              entryRadius: 4, // Add points on the green line
                            ),
                          ],
                          radarBorderData: BorderSide.none,
                          titlePositionPercentageOffset: 0.2,
                          getTitle: (index, _) {
                            return RadarChartTitle(text: categories[index]);
                          },
                          tickCount: 4,
                          ticksTextStyle: TextStyle(
                            color: Colors.transparent,
                            fontSize: 12,
                          ),
                          tickBorderData: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          gridBorderData: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          radarBackgroundColor: Colors.transparent,
                          radarTouchData: RadarTouchData(
                              enabled: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      // Light calm green background (transparent)
                      borderRadius: BorderRadius.circular(12),
                      // Rounded corners
                      border: Border.all(
                        color: Colors.green.shade800,
                        // Dark strong green outline
                        width: 3, // Outline width
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    // Padding inside the container
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '''Today is about reflection and intention. This chart shows how you\'re doing compared to your baseline or target.
                          \nEven if today feels challenging, remember: it\'s about the effort, not perfection. This is a step closer to the future you envision.''',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  const Text(
                    'This Week\'s Performance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Line chart
                  SizedBox(
                    height: 300, // Set a fixed height for charts
                    child: LineChart(
                      LineChartData(
                        maxY: 100,
                        minY: 0,
                        lineBarsData: [
                          LineChartBarData(
                            spots: lineChartPoints,
                            // Data points for the chart
                            isCurved: true,
                            // Smooth line
                            barWidth: 4,
                            color: Colors.blue,
                            dotData: FlDotData(
                              show: true,
                            ), // Show dots on points
                          ),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              interval: 1, // Singular gaps between day labels
                            ),
                          ),
                          topTitles: AxisTitles(
                            axisNameWidget: Text(""),
                            axisNameSize: 0,
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              interval: 25,
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (value, _) {
                                // Show y-axis values
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 12),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(),
                        ),
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        lineTouchData: LineTouchData(
                          enabled: true,
                        ), // Allow touch interactions
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      // Light calm green background (transparent)
                      borderRadius: BorderRadius.circular(12),
                      // Rounded corners
                      border: Border.all(
                        color: Colors.green.shade800,
                        // Dark strong green outline
                        width: 3, // Outline width
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    // Padding inside the container
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '''A week may feel like a small part of the bigger picture, but it's where real habits are built.
                          \nThis graph shows how consistent you’ve been. Celebrate your wins and learn from the harder days.''',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  const Text(
                    'Overall Progress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Bar chart
                  SizedBox(
                    height: 300, // Set a fixed height for charts
                    child: BarChart(
                      BarChartData(
                        maxY: 100,
                        // Set the y-axis range from 0 to 100
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              getTitlesWidget: (value, _) {
                                // Map indices to category names
                                const categories = [
                                  'Reaction',
                                  'Match',
                                  'Shape',
                                  'Face',
                                ];
                                if (value.toInt() < categories.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      categories[value.toInt()],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink(); // Empty space for undefined indices
                              },
                              interval: 1, // Ensure consistent spacing
                            ),
                          ),
                          rightTitles: AxisTitles(),
                          topTitles: AxisTitles(
                            axisNameWidget: Text(""),
                            axisNameSize: 0,
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: 25,
                              getTitlesWidget: (value, _) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 12),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(show: true),
                        // Enable grid lines
                        borderData: FlBorderData(show: true),
                        // Show chart borders
                        barGroups: [
                          // Define data for each bar
                          BarChartGroupData(
                            x: 0, // Index for Reaction Average
                            barRods: [
                              BarChartRodData(
                                toY: results.reactionAverage,
                                // Reaction Average value
                                color: Colors.blue,
                                width: 16,
                                borderRadius: BorderRadius.circular(
                                  4,
                                ), // Rounded corners
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1, // Index for Memory Average
                            barRods: [
                              BarChartRodData(
                                toY: results.memoryAverage,
                                // Memory Average value
                                color: Colors.yellow,
                                width: 16,
                                borderRadius: BorderRadius.circular(
                                  4,
                                ), // Rounded corners
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2, // Index for Shape and Rotation Average
                            barRods: [
                              BarChartRodData(
                                toY: results.psychometricAverage,
                                // Shape and Rotation Average value
                                color: Colors.orange,
                                width: 16,
                                borderRadius: BorderRadius.circular(
                                  4,
                                ), // Rounded corners
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 3, // Index for AI Average
                            barRods: [
                              BarChartRodData(
                                toY: results.AIAverage, // AI Average value
                                color: Colors.purple,
                                width: 16,
                                borderRadius: BorderRadius.circular(
                                  4,
                                ), // Rounded corners
                              ),
                            ],
                          ),
                        ],
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              const categories = [
                                'Reaction Test',
                                'Match Test',
                                'Shape Test',
                                'Face Test',
                              ];
                              return BarTooltipItem(
                                '${categories[group.x]}: ${rod.toY.toStringAsFixed(1)}',
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      // Light calm green background (transparent)
                      borderRadius: BorderRadius.circular(12),
                      // Rounded corners
                      border: Border.all(
                        color: Colors.green.shade800,
                        // Dark strong green outline
                        width: 3, // Outline width
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    // Padding inside the container
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '''This is your story, and this graph captures the progress you've made over time in each area.
                          \nThese metrics are more than just numbers—they represent your resilience, effort, and commitment to a better you.''',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      // Light calm green background (transparent)
                      borderRadius: BorderRadius.circular(12),
                      // Rounded corners
                      border: Border.all(
                        color: Colors.green.shade800,
                        // Dark strong green outline
                        width: 3, // Outline width
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    // Padding inside the container
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Remember Your Motivation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          globalMessage,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartTestPage(),
                        ), // Link to StartTestPage
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Green background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Curved edges
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                    ),
                    child: Text(
                      'Finish',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // White text
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: const Footer(),
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
