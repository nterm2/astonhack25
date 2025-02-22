import 'dart:io';

import 'package:flutter/material.dart';

performScan(String imagePath) async {
  try {
    debugPrint('Starting scan...');
    var result = 
      await Process.run(
              'python',
              [
                'python_code/detect_drunk.py', 
                'assets/test_image.jpg'
              ]
            );

    debugPrint('Scan Result - ${result.stdout}');
    debugPrint('Scan completed.');
  } catch (e) {
    debugPrint("An error occurred:");
    debugPrint('$e');
  }
}