// lib/viewmodels/main_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:analisador_texto_completo/services/text_analyzer_service.dart';

// Modelo de resultados
class AnalysisResult {
  final int sentenceCount;
  final int charCountWithSpaces;
  final int charCountWithoutSpaces;
  final int letterCount;
  final int digitCount;
  final String readingTime;
  final int totalWordCount;

  AnalysisResult({
    required this.sentenceCount,
    required this.charCountWithSpaces,
    required this.charCountWithoutSpaces,
    required this.letterCount,
    required this.digitCount,
    required this.readingTime,
    required this.totalWordCount,
  });
}

class MainViewModel extends ChangeNotifier {
  AnalysisResult? _analyzerResult;
  String _currentText = '';

  AnalysisResult? get analyzerResult => _analyzerResult;
  String get currentText => _currentText;
  
  final TextEditingController textController = TextEditingController();

  void analyzeText(String text) {
    _currentText = text.trim();
    if (_currentText.isEmpty) {
      _analyzerResult = null;
      notifyListeners();
      return;
    }

    final analyzer = TextAnalyzerService(_currentText);
    
    _analyzerResult = AnalysisResult(
      sentenceCount: analyzer.getSentenceCount(),
      charCountWithSpaces: analyzer.getCharCountWithSpaces(),
      charCountWithoutSpaces: analyzer.getCharCountWithoutSpaces(),
      letterCount: analyzer.getLetterCount(),
      digitCount: analyzer.getDigitCount(),
      readingTime: analyzer.getReadingTime(),
      totalWordCount: analyzer.getTotalWordCount(),
    );

    notifyListeners();
  }
  
  void clearText() {
    textController.clear();
    _currentText = '';
    _analyzerResult = null;
    notifyListeners();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}