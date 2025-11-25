// lib/services/text_analyzer_service.dart

/// Implementa as funções de análise de texto.
class TextAnalyzerService {
  final String text;

  TextAnalyzerService(this.text);

  // Contagem de Frases
  int getSentenceCount() {
    RegExp sentenceRegExp = RegExp(r'[.!?](?:\s+|$)');
    return sentenceRegExp.allMatches(text).length;
  }

  // Contagem de Caracteres
  int getCharCountWithSpaces() {
    return text.length;
  }

  int getCharCountWithoutSpaces() {
    return text.replaceAll(RegExp(r'\s'), '').length;
  }

  int getLetterCount() {
    return text.replaceAll(RegExp(r'[^a-zA-ZáàãâéêíóôõúüçÁÀÃÂÉÊÍÓÔÕÚÜÇ]'), '').length;
  }

  int getDigitCount() {
    return text.replaceAll(RegExp(r'[^\d]'), '').length;
  }

  // Estatísticas de Leitura
  String getReadingTime() {
    const int wordsPerMinute = 250;
    String cleanText = text.toLowerCase().replaceAll(RegExp(r'[.,\/#!$%\^&\*;:{}=\-_`~()]'), '');
    List<String> allWords = cleanText.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
    int wordCount = allWords.length;

    if (wordCount == 0) return '0 minutos';

    double minutes = wordCount / wordsPerMinute;
    int min = minutes.floor();
    int seconds = ((minutes - min) * 60).round();

    if (min == 0) {
      return '$seconds segundos';
    } else if (seconds == 0) {
      return '$min minutos';
    } else {
      return '$min minutos e $seconds segundos';
    }
  }

  // Contagem Total de Palavras
  int getTotalWordCount() {
    String cleanText = text.toLowerCase().replaceAll(RegExp(r'[.,\/#!$%\^&\*;:{}=\-_`~()]'), '');
    List<String> allWords = cleanText.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
    return allWords.length;
  }
}