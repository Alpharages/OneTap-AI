class QuranVerse {
  final int surahNumber;
  final int verseNumber;
  final String arabicText;
  final String transliteration;
  final String translation;
  final String audioUrl;

  QuranVerse({
    required this.surahNumber,
    required this.verseNumber,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.audioUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'verseNumber': verseNumber,
      'arabicText': arabicText,
      'transliteration': transliteration,
      'translation': translation,
      'audioUrl': audioUrl,
    };
  }

  factory QuranVerse.fromJson(Map<String, dynamic> json) {
    return QuranVerse(
      surahNumber: json['surahNumber'] ?? 1,
      verseNumber: json['verseNumber'] ?? 1,
      arabicText: json['arabicText'] ?? '',
      transliteration: json['transliteration'] ?? '',
      translation: json['translation'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
    );
  }
} 