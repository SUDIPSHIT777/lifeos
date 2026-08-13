import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator/translator.dart';

class LanguageModel {
  final String name;
  final String code;
  final String flag;

  const LanguageModel({
    required this.name,
    required this.code,
    required this.flag,
  });
}

class TranslationHistoryItem {
  final String sourceText;
  final String translatedText;
  final String sourceLang;
  final String targetLang;
  final DateTime timestamp;

  TranslationHistoryItem({
    required this.sourceText,
    required this.translatedText,
    required this.sourceLang,
    required this.targetLang,
    required this.timestamp,
  });
}

class TranslateProvider extends ChangeNotifier {
  final GoogleTranslator _translator = GoogleTranslator();
  final TextEditingController sourceController = TextEditingController();

  static const List<LanguageModel> supportedLanguages = [
    LanguageModel(name: 'Auto Detect', code: 'auto', flag: '🌐'),
    LanguageModel(name: 'English', code: 'en', flag: '🇺🇸'),
    LanguageModel(name: 'Bengali', code: 'bn', flag: '🇧🇩'),
    LanguageModel(name: 'Hindi', code: 'hi', flag: '🇮🇳'),
    LanguageModel(name: 'Spanish', code: 'es', flag: '🇪🇸'),
    LanguageModel(name: 'French', code: 'fr', flag: '🇫🇷'),
    LanguageModel(name: 'German', code: 'de', flag: '🇩🇪'),
    LanguageModel(name: 'Chinese', code: 'zh-cn', flag: '🇨🇳'),
    LanguageModel(name: 'Japanese', code: 'ja', flag: '🇯🇵'),
    LanguageModel(name: 'Korean', code: 'ko', flag: '🇰🇷'),
    LanguageModel(name: 'Arabic', code: 'ar', flag: '🇸🇦'),
    LanguageModel(name: 'Russian', code: 'ru', flag: '🇷🇺'),
    LanguageModel(name: 'Portuguese', code: 'pt', flag: '🇵🇹'),
    LanguageModel(name: 'Italian', code: 'it', flag: '🇮🇹'),
    LanguageModel(name: 'Tamil', code: 'ta', flag: '🇮🇳'),
    LanguageModel(name: 'Telugu', code: 'te', flag: '🇮🇳'),
    LanguageModel(name: 'Marathi', code: 'mr', flag: '🇮🇳'),
    LanguageModel(name: 'Gujarati', code: 'gu', flag: '🇮🇳'),
    LanguageModel(name: 'Kannada', code: 'kn', flag: '🇮🇳'),
    LanguageModel(name: 'Malayalam', code: 'ml', flag: '🇮🇳'),
    LanguageModel(name: 'Punjabi', code: 'pa', flag: '🇮🇳'),
    LanguageModel(name: 'Urdu', code: 'ur', flag: '🇵🇰'),
    LanguageModel(name: 'Turkish', code: 'tr', flag: '🇹🇷'),
    LanguageModel(name: 'Vietnamese', code: 'vi', flag: '🇻🇳'),
    LanguageModel(name: 'Indonesian', code: 'id', flag: '🇮🇩'),
    LanguageModel(name: 'Dutch', code: 'nl', flag: '🇳🇱'),
    LanguageModel(name: 'Polish', code: 'pl', flag: '🇵🇱'),
  ];

  static List<LanguageModel> get targetLanguages =>
      supportedLanguages.where((l) => l.code != 'auto').toList();

  LanguageModel _sourceLanguage = const LanguageModel(
    name: 'Bengali',
    code: 'bn',
    flag: '🇧🇩',
  );
  LanguageModel _targetLanguage = const LanguageModel(
    name: 'Hindi',
    code: 'hi',
    flag: '🇮🇳',
  );

  String _translatedText = '';
  bool _isLoading = false;
  String? _errorMessage;
  final List<TranslationHistoryItem> _history = [];

  LanguageModel get sourceLanguage => _sourceLanguage;
  LanguageModel get targetLanguage => _targetLanguage;
  String get translatedText => _translatedText;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<TranslationHistoryItem> get history => List.unmodifiable(_history);

  TranslateProvider() {
    sourceController.addListener(_onSourceTextChanged);
  }

  void _onSourceTextChanged() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void setSourceLanguage(LanguageModel lang) {
    if (_sourceLanguage.code == lang.code) return;
    _sourceLanguage = lang;
    if (_sourceLanguage.code == _targetLanguage.code) {
      // Pick another target language if source matches target
      _targetLanguage = targetLanguages.firstWhere(
        (l) => l.code != lang.code,
        orElse: () => targetLanguages.first,
      );
    }
    notifyListeners();
    if (sourceController.text.trim().isNotEmpty) {
      translate();
    }
  }

  void setTargetLanguage(LanguageModel lang) {
    if (_targetLanguage.code == lang.code) return;
    _targetLanguage = lang;
    notifyListeners();
    if (sourceController.text.trim().isNotEmpty) {
      translate();
    }
  }

  void swapLanguages() {
    if (_sourceLanguage.code == 'auto') return;

    final temp = _sourceLanguage;
    _sourceLanguage = _targetLanguage;
    _targetLanguage = temp;

    if (_translatedText.isNotEmpty) {
      final oldTranslation = _translatedText;
      sourceController.text = oldTranslation;
      _translatedText = '';
      translate();
    } else {
      notifyListeners();
    }
  }

  Future<void> translate() async {
    final text = sourceController.text.trim();
    if (text.isEmpty) {
      _errorMessage = 'Please enter text to translate';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final translation = await _translator.translate(
        text,
        from: _sourceLanguage.code,
        to: _targetLanguage.code,
      );

      _translatedText = translation.text;

      _addToHistory(
        sourceText: text,
        translatedText: _translatedText,
        sourceLang: _sourceLanguage.name,
        targetLang: _targetLanguage.name,
      );
    } catch (e) {
      _errorMessage =
          'Could not complete translation. Please check your network.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _addToHistory({
    required String sourceText,
    required String translatedText,
    required String sourceLang,
    required String targetLang,
  }) {
    // Avoid duplicate top item
    if (_history.isNotEmpty &&
        _history.first.sourceText == sourceText &&
        _history.first.targetLang == targetLang) {
      return;
    }

    _history.insert(
      0,
      TranslationHistoryItem(
        sourceText: sourceText,
        translatedText: translatedText,
        sourceLang: sourceLang,
        targetLang: targetLang,
        timestamp: DateTime.now(),
      ),
    );

    if (_history.length > 15) {
      _history.removeLast();
    }
  }

  Future<void> pasteText() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text != null && data!.text!.trim().isNotEmpty) {
      sourceController.text = data.text!;
      notifyListeners();
      translate();
    }
  }

  void clearAll() {
    sourceController.clear();
    _translatedText = '';
    _errorMessage = null;
    notifyListeners();
  }

  void copyTranslation(BuildContext context) {
    if (_translatedText.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _translatedText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Translation copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void copySource(BuildContext context) {
    if (sourceController.text.trim().isEmpty) return;
    Clipboard.setData(ClipboardData(text: sourceController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Source text copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void selectHistoryItem(TranslationHistoryItem item) {
    sourceController.text = item.sourceText;
    _translatedText = item.translatedText;
    final src = supportedLanguages.firstWhere(
      (l) => l.name == item.sourceLang,
      orElse: () => _sourceLanguage,
    );
    final tgt = targetLanguages.firstWhere(
      (l) => l.name == item.targetLang,
      orElse: () => _targetLanguage,
    );
    _sourceLanguage = src;
    _targetLanguage = tgt;
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    sourceController.removeListener(_onSourceTextChanged);
    sourceController.dispose();
    super.dispose();
  }
}
