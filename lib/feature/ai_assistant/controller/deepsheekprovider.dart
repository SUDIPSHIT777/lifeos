import 'package:flutter/material.dart';
import 'package:lifeos/feature/ai_assistant/service/deepsheekapi.dart';

class ChatMessage {
  String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class Deepsheekprovider extends ChangeNotifier {
  final DeepSheekApi _api = DeepSheekApi();

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(ChatMessage(text: text, isUser: true));
    
    final aiMessage = ChatMessage(text: '', isUser: false);
    _messages.add(aiMessage);

    _loading = true;
    notifyListeners();

    try {
      final stream = _api.chatStream(text);
      await for (final chunk in stream) {
        if (_loading) {
          _loading = false; // Turn off initial loading once stream starts
        }
        aiMessage.text += chunk;
        notifyListeners();
      }
    } catch (e) {
      aiMessage.text = 'Error: Could not get a response.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}