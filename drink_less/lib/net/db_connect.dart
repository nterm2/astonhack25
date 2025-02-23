import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

// Currently the emulator local host -- change accordingly when hosted properly
final databaseDomain = 'http://10.0.2.2:5000';

Future<void> insertIntoDatabase(
  double reactionResult,
  double memoryResult,
  double psychometricResult,
  double aiScore,
  String aiResult
) async {
    try {
      final message = {
        "reactionScore" : reactionResult,
        "memoryScore" : memoryResult,
        "psychometricScore" : psychometricResult,
        "AIScore" : aiScore,
        "AIResult" : aiResult
      };

      debugPrint('$message');

      final url = '$databaseDomain/insert-results';
      final headers = 
          {'Content-Type': 'application/json'};

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body :  jsonEncode(message),
      );

      if (response.statusCode == 200) {
        debugPrint('Success: ${response.body}');
      } else {
        debugPrint(
            'Error: Status Code ${response.statusCode}, Response: ${response.body}'
        );
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
    }
}


Future<void> getLatestResultsFromDatabase() async {
    try {

      final url = '$databaseDomain/get-latest-results';
      final headers = 
          {'Content-Type': 'application/json'};

      final response = await http.get(
          Uri.parse(url), headers: headers
      );

      if (response.statusCode == 200) {
        debugPrint('Success: ${response.body}');
      } else {
        debugPrint(
            'Error: Status Code ${response.statusCode}, Response: ${response.body}'
        );
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
    }
}


Future<void> getAverageResultsThisWeek() async {
    try {

      final url = '$databaseDomain/get-week-average';
      final headers = 
          {'Content-Type': 'application/json'};

      final response = await http.get(
          Uri.parse(url), headers: headers
      );

      if (response.statusCode == 200) {
        debugPrint('Success: ${response.body}');
      } else {
        debugPrint(
            'Error: Status Code ${response.statusCode}, Response: ${response.body}'
        );
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
    }
}

Future<void> getOverallProgress() async {
    try {

      final url = '$databaseDomain/get-overall-progress';
      final headers = 
          {'Content-Type': 'application/json'};

      final response = await http.get(
          Uri.parse(url), headers: headers
      );

      if (response.statusCode == 200) {
        debugPrint('Success: ${response.body}');
      } else {
        debugPrint(
            'Error: Status Code ${response.statusCode}, Response: ${response.body}'
        );
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
    }
}

Future<void> getStreak() async {
    try {

      final url = '$databaseDomain/get-streak';
      final headers = 
          {'Content-Type': 'application/json'};

      final response = await http.get(
          Uri.parse(url), headers: headers
      );

      if (response.statusCode == 200) {
        debugPrint('Success: ${response.body}');
      } else {
        debugPrint(
            'Error: Status Code ${response.statusCode}, Response: ${response.body}'
        );
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
    }
}

Future<void> getResultsData() async {
    try {

      final url = '$databaseDomain/get-results-data';
      final headers = 
          {'Content-Type': 'application/json'};

      final response = await http.get(
          Uri.parse(url), headers: headers
      );

      if (response.statusCode == 200) {
        debugPrint('Success: ${response.body}');
      } else {
        debugPrint(
            'Error: Status Code ${response.statusCode}, Response: ${response.body}'
        );
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
    }
}


Future<void> getStreakData() async {
    try {

      final url = '$databaseDomain/get-streak-data';
      final headers = 
          {'Content-Type': 'application/json'};

      final response = await http.get(
          Uri.parse(url), headers: headers
      );

      if (response.statusCode == 200) {
        debugPrint('Success: ${response.body}');
      } else {
        debugPrint(
            'Error: Status Code ${response.statusCode}, Response: ${response.body}'
        );
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
    }
}