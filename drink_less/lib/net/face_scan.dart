import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

Future<String?> getFaceScan(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);

      final bytes = data.buffer.asUint8List();
      debugPrint('Raw Bytes Data : $bytes\n');

      final message = base64Encode(bytes);
      debugPrint('Base-64 encoding : $message\n');

      debugPrint('Decoded Encoding : ${base64Decode(message)}\n');

      debugPrint(message);

      final model = 'drunk-or-sober-iwnwj/1';

      final apiKey = '22tzVfDkBC7oIorFHU2Y';

      final url =
          'https://classify.roboflow.com/$model?api_key=$apiKey';

      final headers = 
          {'Content-Type': 'application/x-www-form-urlencoded'};

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body :  message,
      );

      if (response.statusCode == 200) {
        debugPrint('Success: ${response.body}');
        return response.body;
      } else {
        debugPrint(
            'Error: Status Code ${response.statusCode}, Response: ${response.body}'
        );
        return "An error occurred while fetching data";
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      return "An error occurred while fetching data";
    }
}

