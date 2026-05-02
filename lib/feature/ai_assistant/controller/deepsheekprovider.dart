import 'package:flutter/material.dart';
import 'package:lifeos/feature/ai_assistant/service/deepsheekapi.dart';

class Deepsheekprovider extends ChangeNotifier {
  final DeepSheekApi _api = DeepSheekApi();

  String _response = '';
  String get response => _response;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> fetchGreeting() async {
    _loading = true;
    notifyListeners();

    _response = await _api.chat('Hello');

    _loading = false;
    notifyListeners();
  }
}