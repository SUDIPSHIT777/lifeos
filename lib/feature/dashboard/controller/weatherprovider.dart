import 'dart:developer';

import 'package:flutter/material.dart';
import '../service/weather.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service = WeatherService();

  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWeather() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await _service.getWeatherFromCurrentLocation();
      _weatherData = data;
    } catch (e) {
      log('error${e.toString()}');
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await fetchWeather();
  }

  Map<String, dynamic>? get weatherAdvice {
    if (_weatherData == null) return null;

    final current = _weatherData!['current'];

    final temp = current['temp_c'];
    final humidity = current['humidity'];
    final wind = current['wind_kph'];
    final condition = current['condition']['text'].toLowerCase();

    final isClear = condition.contains("sun") || condition.contains("clear");
    final goodTemp = temp >= 18 && temp <= 35;
    final lowHumidity = humidity <= 90;
    final lowWind = wind <= 25;

    final isGoodWeather = isClear && goodTemp && lowHumidity && lowWind;

    if (isGoodWeather) {
      return {
        "message": "Perfect weather! Go outside 🌤",
        "image": "assets/Girl on bike.json",
        "color": Colors.green,
      };
    } else {
      return {
        "message": "Better stay inside ☁️",
        "image": "assets/Bad weather.json",
        "color": Colors.red,
      };
    }
  }
}
