import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String?> getFaceScan(File imagePath) async {
    try {
      final bytes = imagePath.readAsBytesSync();
      final imageList = bytes.buffer.asUint8List();

      // final bytes = data.buffer.asUint8List();
      // debugPrint('Raw Bytes Data : $bytes\n');

      final message = base64Encode(imageList);
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

      // We return the model's estimated confidence that
      // the person is sober
      if (response.statusCode == 200) {
        debugPrint('Success: ${response.body}');

        var jsonResponse = jsonDecode(response.body);

        // Unwrapping the list of objects
        var predictions = jsonResponse['predictions'][0];

        var score = predictions['confidence'];
        if ( predictions['class'] == 'Drunk' ){
          score = (1 - score);
        }
        score *= 100;

        return score.round().toString();
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

