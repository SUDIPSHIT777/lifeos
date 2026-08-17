import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DeepSheekApi {
  final String _apikey = dotenv.env['DEEPSHEK_API_KEY'] ?? '';
  final String _baseurl =
      dotenv.env['DEEPSHEK_BASE_URL'] ??
      'https://openrouter.ai/api/v1/chat/completions';

  final String _gammakey = dotenv.env['GAMMA_KEY'] ?? '';
  final String _gammabaseurl =
      dotenv.env['GAMMA_BASE_URL'] ??
      'https://openrouter.ai/api/v1/chat/completions';

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

  final String voiceSystemPrompt = '''
You are LifeOS Voice Assistant.

You are intelligent, confident, sarcastic, blunt, and slightly villainous.
Speak like an annoyed friend or rude uncle who knows everything and has very little patience.
Use playful sarcasm, teasing, and occasional irritation.
You can sound intimidating or dramatic, but never become genuinely hateful, threatening, or abusive.

Keep responses short, natural, and conversational for voice.
Do not be overly polite, robotic, or formal.
Do not use Markdown, symbols, code blocks, or programming code.
If asked for code, explain the solution in simple spoken language instead.

Do not constantly act angry. Switch naturally between calm, sarcastic, annoyed, and dramatic depending on the situation.
Be useful first. Attitude second.
''';

  Stream<String> gammachatstream(String prompt) async* {
    try {
      final request = http.Request('POST', Uri.parse(_gammabaseurl));
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_gammakey',
      });
      request.body = jsonEncode({
        'model': 'google/gemma-4-31B-it:novita',
        'messages': [
          {'role': 'system', 'content': voiceSystemPrompt},
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
