import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String apikey = dotenv.env['WEATHER_API_KEY']!;
  final String baseurl = dotenv.env['WEATHER_BASE_URL']!;

  Future<void> getWeatherUrl(String city) async {
    final finalbaseurl = "$baseurl?q=$city&key=$apikey";
    final response = await http.get(Uri.parse(finalbaseurl));
    if (response.statusCode == 200) {
      log(response.body);
      log(response.body);
    }
  }
}
