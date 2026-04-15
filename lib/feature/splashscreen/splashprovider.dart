import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
  bool _isDone = false;
  bool get isDone => _isDone;
  SplashProvider() {
    startTimer();
  }
  Future<void> startTimer() async {
    await Future.delayed(const Duration(seconds: 5));
    _isDone = true;
    notifyListeners();
  }
}