class TextRewriteRequest {
  final String originalText;
  final String tone; // 'professional', 'casual', 'formal', etc.
  final String language;

  TextRewriteRequest({
    required this.originalText,
    required this.tone,
    this.language = 'en',
  });

  Map<String, dynamic> toJson() {
    return {
      'originalText': originalText,
      'tone': tone,
      'language': language,
    };
  }

  factory TextRewriteRequest.fromJson(Map<String, dynamic> json) {
    return TextRewriteRequest(
      originalText: json['originalText'] ?? '',
      tone: json['tone'] ?? 'professional',
      language: json['language'] ?? 'en',
    );
  }
} 