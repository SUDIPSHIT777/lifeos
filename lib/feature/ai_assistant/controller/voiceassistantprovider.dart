import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:lifeos/feature/ai_assistant/service/deepsheekapi.dart';

class VoiceAssistantProvider extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final DeepSheekApi _api = DeepSheekApi();

  bool _isInitialized = false;
  bool _isListening = false;
  bool _isProcessing = false;
  bool _isSpeaking = false;

  String _userText = '';
  String _aiResponse = '';
  String _status = 'Tap mic to talk';

  // Getters
  bool get isListening => _isListening;
  bool get isProcessing => _isProcessing;
  bool get isSpeaking => _isSpeaking;
  String get userText => _userText;
  String get aiResponse => _aiResponse;
  String get status => _status;

  VoiceAssistantProvider() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('en-US');
    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
      _status = 'Speaking...';
      notifyListeners();
    });
    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      _status = 'Tap mic to talk';
      notifyListeners();
    });
    _flutterTts.setCancelHandler(() {
      _isSpeaking = false;
      _status = 'Tap mic to talk';
      notifyListeners();
    });
  }

  Future<void> _initStt() async {
    if (!_isInitialized) {
      _isInitialized = await _speechToText.initialize(
        onStatus: (st) {
          if ((st == 'done' || st == 'notListening') && _isListening) {
            _isListening = false;
            notifyListeners();
            if (_userText.trim().isNotEmpty) {
              _processVoiceQuery(_userText.trim());
            }
          }
        },
      );
    }
  }

  Future<void> toggleListening() async {
    if (_isSpeaking) {
      await stopSpeaking();
      return;
    }

    if (_isListening) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  Future<void> startListening() async {
    await stopSpeaking();
    await _initStt();

    if (!_isInitialized) {
      _status = 'Microphone unavailable';
      notifyListeners();
      return;
    }

    _userText = '';
    _aiResponse = '';
    _isListening = true;
    _status = 'Listening...';
    notifyListeners();

    await _speechToText.listen(
      onResult: (SpeechRecognitionResult res) {
        _userText = res.recognizedWords;
        if (res.finalResult && _userText.trim().isNotEmpty) {
          _speechToText.stop();
        }
        notifyListeners();
      },
      listenOptions: SpeechListenOptions(
        cancelOnError: true,
        partialResults: true,
      ),
    );
  }

  Future<void> stopListening() async {
    if (!_isListening) return;
    _isListening = false;
    notifyListeners();
    await _speechToText.stop();

    if (_userText.trim().isNotEmpty) {
      await _processVoiceQuery(_userText.trim());
    } else {
      _status = 'Tap mic to talk';
      notifyListeners();
    }
  }

  Future<void> _processVoiceQuery(String query) async {
    _isProcessing = true;
    _aiResponse = '';
    _status = 'Thinking...';
    notifyListeners();

    try {
      final stream = _api.gammachatstream(query);
      await for (final chunk in stream) {
        _aiResponse += chunk;
        notifyListeners();
      }
    } catch (_) {
      _aiResponse = 'Sorry, error occurred.';
    } finally {
      _isProcessing = false;
      notifyListeners();
      if (_aiResponse.trim().isNotEmpty) {
        await _speak(_aiResponse);
      } else {
        _status = 'Tap mic to talk';
        notifyListeners();
      }
    }
  }

  Future<void> _speak(String text) async {
    final cleanText = text
        .replaceAll(RegExp(r'\*+|_+|#+|`+|>+'), '')
        .replaceAll(RegExp(r'\[(.*?)\]\(.*?\)', caseSensitive: false), '\$1')
        .trim();

    _isSpeaking = true;
    _status = 'Speaking...';
    notifyListeners();
    await _flutterTts.speak(cleanText);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
    _isSpeaking = false;
    _status = 'Tap mic to talk';
    notifyListeners();
  }

  @override
  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }
}
