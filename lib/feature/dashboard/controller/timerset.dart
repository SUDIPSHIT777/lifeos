import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class FocusTimerProvider extends ChangeNotifier {
  int _totalSeconds = 25 * 60;
  int _remainingSeconds = 25 * 60;

  Timer? _timer;
  bool _isRunning = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;

  String get formattedTime {
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;

    if (hours > 0) {
      return "${hours.toString()}:"
          "${minutes.toString().padLeft(2, '0')}:"
          "${seconds.toString().padLeft(2, '0')}";
    }

    return "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  void setMinutes(int minutes) {
    if (minutes <= 0) return;
    _audioPlayer.stop();
    _stopTimer();
    _totalSeconds = minutes * 60;
    _remainingSeconds = _totalSeconds;
    _stopTimer();
    notifyListeners();
  }

  void start() {
    if (_isRunning || _remainingSeconds == 0) return;

    _isRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _complete();
      }
    });
  }

  void pause() {
    if (!_isRunning) return;
    _stopTimer();
    notifyListeners();
  }

  void reset() {
    _stopTimer();
    _remainingSeconds = _totalSeconds;
    _audioPlayer.stop();
    notifyListeners();
  }

  void _stopTimer() {
    _timer?.cancel();
    _isRunning = false;
  }

  Future<void> _complete() async {
    _stopTimer();
    notifyListeners();
    try {
      await _audioPlayer.play(AssetSource('alearm.mp3'));
    } catch (_) {}
  }

  double _pickerMinutes = 25;
  double get pickerMinutes => _pickerMinutes;

  void updatePicker(double value) {
    _pickerMinutes = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
