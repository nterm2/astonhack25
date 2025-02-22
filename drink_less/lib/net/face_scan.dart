import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

Future<void> getFaceScan(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);

      final bytes = data.buffer.asUint8List();
      debugPrint('Raw Bytes Data : $bytes\n');

      final message = base64Encode(bytes);
      debugPrint('Base-64 encoding : $message\n');

      debugPrint('Decoded Encoding : ${base64Decode(message)}\n');

      // String base64Image = "";

      // if (buffer.isNotEmpty){
      //   base64Image = base64Encode(imageList);
      // } else {
      //   debugPrint("No image list found");
      //   throw UnimplementedError();
      // }

      // debugPrint('$base64Image\n');

      debugPrint(message);

      final model = 'drunk-or-sober-iwnwj/1';

      final apiKey = '22tzVfDkBC7oIorFHU2Y';

      final url =
          'https://classify.roboflow.com/$model?api_key=$apiKey';

      final headers = 
          {'Content-Type': 'application/x-www-form-urlencoded'};
          // {'Content-Type': 'application/json'};

      // final body = {
      //   "data": message,
      // };
      final body = {'image' : message};

      // final encodedBody = Uri(queryParameters: body).query;

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        // body: encodedBody,
        body :  body,
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

/*
Future<void> getFaceScan(File imagePath) async {
    try {
      final bytes = imagePath.readAsBytesSync();
      final imageList = bytes.buffer.asUint8List();

      String base64Image = "";

      if (imageList.isNotEmpty){
        base64Image = base64Encode(imageList);
      } else {
        debugPrint("No image list found");
        throw UnimplementedError();
      }

      final model = 'drunk-or-sober-iwnwj/1';

      final apiKey = '22tzVfDkBC7oIorFHU2Y';

      final url =
          'https://classify.roboflow.com/$model?api_key=$apiKey';
      final headers = {'Content-Type': 'application/x-www-form-urlencoded'};

      final body = {
        "data": base64Image,
      };

      final encodedBody = Uri(queryParameters: body).query;
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: encodedBody,
      );

      if (response.statusCode == 200) {
        debugPrint('Success: ${response.body}');
      } else {
        debugPrint(
            'Error: Status Code ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
    }
}
*/

/*
  Initial attempt using internal processes within Flutter.
  Runs into issues as it requires a python binary to be installed
  within the application.
  Could potentially be retried though.

performScan(String imagePath) async {
  try {
    debugdebugPrint('Starting scan...');
    var result = 
      await Process.run(
              'python',
              [
                'lib/net/python_code/detect_drunk.py', 
                imagePath,
              ]
            );

    debugdebugPrint('Scan Result - ${result.stdout}');
    debugdebugPrint('Scan completed.');
  } catch (e) {
    debugdebugPrint("An error occurred:");
    debugdebugPrint('$e');
  }
}

*/

