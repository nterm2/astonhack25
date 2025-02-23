import 'package:flutter/material.dart';

class FormStateProvider with ChangeNotifier {
  Map<String, dynamic> _formData = {};

  Map<String, dynamic> get formData => _formData;

  void updateData(String key, dynamic value) {
    _formData[key] = value;
    notifyListeners(); // Update UI when state changes
  }

  void clearData() {
    _formData.clear();
    notifyListeners();
  }
}
