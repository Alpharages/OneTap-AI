class TranslationRequest {
  final String text;
  final String sourceLanguage;
  final String targetLanguage;

  TranslationRequest({
    required this.text,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
    };
  }

  factory TranslationRequest.fromJson(Map<String, dynamic> json) {
    return TranslationRequest(
      text: json['text'] ?? '',
      sourceLanguage: json['sourceLanguage'] ?? 'auto',
      targetLanguage: json['targetLanguage'] ?? 'en',
    );
  }
} 