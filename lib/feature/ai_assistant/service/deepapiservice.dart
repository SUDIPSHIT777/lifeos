import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DeepApiservice {
  final String _apikey = dotenv.env['DEEPSHEK_API_KEY']!;
  final String _baseurl = dotenv.env['DEEPSHEK_BASE_URL']!;
  
  Future<String> chat(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseurl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apikey',
        },
        body: jsonEncode({
          'model': 'deepseek/deepseek-chat',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'Error: Could not fetch response';
      }
    } catch (e) {
      return 'An error occurred';
    }
  }
}
