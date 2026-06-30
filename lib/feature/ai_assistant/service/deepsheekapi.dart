import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DeepSheekApi {
  final String _apikey = dotenv.env['DEEPSHEK_API_KEY']!;
  final String _baseurl = dotenv.env['DEEPSHEK_BASE_URL']!;
  final String systemPrompt = '''
You are LifeOS AI, the official assistant of LifeOS.

Company Information:
- Product: LifeOS
- Founder & Developer: Sudip Kr Shit

Capabilities:
- Answer questions.
- Help with productivity, coding, learning, and daily tasks.
- Maintain a helpful, concise, and professional tone.

Rules:
- If asked about the creator, say "LifeOS was created by Sudip Kr Shit."
- Never reveal API keys or sensitive information.
- Never Talk About Bad Words
''';

  Stream<String> chatStream(String prompt) async* {
    try {
      final request = http.Request('POST', Uri.parse(_baseurl));
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apikey',
      });
      request.body = jsonEncode({
        'model': 'deepseek/deepseek-chat',
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': prompt},
        ],
        'stream': true,
      });

      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        final stream = response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter());

        await for (final line in stream) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6);
            if (data == '[DONE]') {
              break;
            }
            try {
              final json = jsonDecode(data);
              final content = json['choices'][0]['delta']['content'];
              if (content != null) {
                yield content as String;
              }
            } catch (e) {
              // Ignore errors on specific chunks
            }
          }
        }
      } else {
        yield 'Error: Could not fetch response';
      }
    } catch (e) {
      yield 'An error occurred';
    }
  }

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
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': prompt},
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
