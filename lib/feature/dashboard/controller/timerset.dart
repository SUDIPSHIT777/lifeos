import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class FocusTimerProvider extends ChangeNotifier {
  int _totalSeconds = 25 * 60;
  int _remainingSeconds = 25 * 60;

  Timer? _timer;
  bool _isRunning = false;

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;

  final AudioPlayer _audioPlayer = AudioPlayer();

  String get formattedTime {
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;
    if (hours > 0) {
      return "${hours.toString().padLeft(2, '0')}:"
          "${minutes.toString().padLeft(2, '0')}:"
          "${seconds.toString().padLeft(2, '0')}";
    }
    return "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  // ✅ SET CUSTOM TIME (minutes)
  void setMinutes(int minutes) {
    if (minutes <= 0) return;
    _totalSeconds = minutes * 60;
    _remainingSeconds = _totalSeconds;
    _stopInternal();
    notifyListeners();
  }

  // ✅ SET CUSTOM TIME (hours + minutes)
  void setDuration({int hours = 0, int minutes = 0}) {
    final total = (hours * 3600) + (minutes * 60);
    if (total <= 0) return;
    _totalSeconds = total;
    _remainingSeconds = total;
    _stopInternal();
    notifyListeners();
  }

  void start({VoidCallback? onComplete}) {
    if (_isRunning || _remainingSeconds == 0) return;
    _isRunning = true;
    notifyListeners();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        stop();
        _onTimerComplete();
        if (onComplete != null) onComplete();
      }
    });
  }

  void pause() {
    if (!_isRunning) return;
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void stop() {
    _stopInternal();
    notifyListeners();
  }

  void reset() {
    _stopInternal();
    _remainingSeconds = _totalSeconds;
    _audioPlayer.stop();
    notifyListeners();
  }

  void _stopInternal() {
    _timer?.cancel();
    _isRunning = false;
  }

  Future<void> _onTimerComplete() async {
    stop();
    try {
      await _audioPlayer.play(AssetSource('alearm.mp3'));
    } catch (e) {
      debugPrint("Audio error: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
