import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

class WeatherService {
  final String _apikey = dotenv.env['WEATHER_API_KEY']!;
  final String _baseurl = dotenv.env['WEATHER_BASE_URL']!;
  Future<Map<String, dynamic>> weatherFetch(double lat, double lon) async {
    final Uri url = Uri.parse("$_baseurl?key=$_apikey&q=$lat,$lon");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Weather API error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception("Please enable location services.");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      throw Exception("Location permanently denied.");
    }
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<Map<String, dynamic>> getWeatherFromCurrentLocation() async {
    final position = await getCurrentLocation();
    return await weatherFetch(position.latitude, position.longitude);
  }
}
