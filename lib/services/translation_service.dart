import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/translation_request.dart';

class TranslationService {
  // Gemini API Configuration
  static const String _geminiApiKey = '';
  static const String _geminiApiUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';
  
  // Static data for fallback - in production this would call translation API
  static final Map<String, Map<String, String>> _staticTranslations = {
    'en': {
      'hello': 'Hello',
      'thank you': 'Thank you',
      'good morning': 'Good morning',
      'how are you': 'How are you?',
      'goodbye': 'Goodbye',
    },
    'es': {
      'hello': 'Hola',
      'thank you': 'Gracias',
      'good morning': 'Buenos días',
      'how are you': '¿Cómo estás?',
      'goodbye': 'Adiós',
    },
    'fr': {
      'hello': 'Bonjour',
      'thank you': 'Merci',
      'good morning': 'Bonjour',
      'how are you': 'Comment allez-vous?',
      'goodbye': 'Au revoir',
    },
    'ar': {
      'hello': 'مرحبا',
      'thank you': 'شكرا لك',
      'good morning': 'صباح الخير',
      'how are you': 'كيف حالك؟',
      'goodbye': 'وداعا',
    },
    'zh': {
      'hello': '你好',
      'thank you': '谢谢',
      'good morning': '早上好',
      'how are you': '你好吗？',
      'goodbye': '再见',
    },
  };

  static Future<String> translateText(TranslationRequest request) async {
    try {
      final result = await _callGeminiTranslation(request);
      if (result.isNotEmpty) {
        return result;
      }
    } catch (e) {
      print('Gemini translation failed, using fallback: $e');
      // Fallback to static translation
      return _fallbackTranslation(request);
    }
    
    return _fallbackTranslation(request);
  }

  static Future<String> _callGeminiTranslation(TranslationRequest request) async {
    try {
      final sourceLang = request.sourceLanguage.toLowerCase();
      final targetLang = request.targetLanguage.toLowerCase();
      final text = request.text.trim();
      
      // If source is auto, try to detect language
      String detectedLang = sourceLang;
      if (sourceLang == 'auto') {
        detectedLang = _detectLanguage(text);
      }
      
      final prompt = _buildTranslationPrompt(text, detectedLang, targetLang);
      
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': prompt,
              },
            ],
          },
        ],
      };
      
      print('Making Gemini Translation API call...');
      print('Translating from ${getLanguageName(detectedLang)} to ${getLanguageName(targetLang)}');
      
      final response = await http.post(
        Uri.parse('$_geminiApiUrl?key=$_geminiApiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - Gemini API took too long to respond');
        },
      );
      
      print('Gemini Translation API Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data.containsKey('candidates') && data['candidates'] != null) {
          final candidates = data['candidates'] as List;
          if (candidates.isNotEmpty) {
            final content = candidates[0]['content'];
            if (content != null && content.containsKey('parts')) {
              final parts = content['parts'] as List;
              if (parts.isNotEmpty && parts[0].containsKey('text')) {
                return parts[0]['text'].toString().trim();
              }
            }
          }
        }
        
        throw Exception('Unexpected response structure from Gemini API');
      } else {
        final errorBody = response.body;
        print('Gemini Translation API Error: $errorBody');
        throw Exception('Gemini Translation API error: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      print('Gemini Translation API Exception: $e');
      throw Exception('Gemini Translation API error: $e');
    }
  }

  static String _buildTranslationPrompt(String text, String sourceLang, String targetLang) {
    final sourceLangName = getLanguageName(sourceLang);
    final targetLangName = getLanguageName(targetLang);
    
    return 'Translate the following text from $sourceLangName to $targetLangName. Only return the translated text, no explanations or additional text:\n\n"$text"';
  }

  static Future<String> _fallbackTranslation(TranslationRequest request) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    final sourceLang = request.sourceLanguage.toLowerCase();
    final targetLang = request.targetLanguage.toLowerCase();
    final text = request.text.toLowerCase().trim();
    
    // If source is auto, try to detect language
    String detectedLang = sourceLang;
    if (sourceLang == 'auto') {
      detectedLang = _detectLanguage(text);
    }
    
    // Get translation
    if (_staticTranslations.containsKey(targetLang) && 
        _staticTranslations[targetLang]!.containsKey(text)) {
      return _staticTranslations[targetLang]![text]!;
    }
    
    // If no exact match, try to translate word by word
    return _translateWordByWord(text, detectedLang, targetLang);
  }

  static String _detectLanguage(String text) {
    // Simple language detection based on character sets
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(text)) {
      return 'ar'; // Arabic
    } else if (RegExp(r'[\u4E00-\u9FFF]').hasMatch(text)) {
      return 'zh'; // Chinese
    } else if (text.contains('ñ') || text.contains('á') || text.contains('é')) {
      return 'es'; // Spanish
    } else if (text.contains('é') || text.contains('à') || text.contains('ç')) {
      return 'fr'; // French
    } else {
      return 'en'; // Default to English
    }
  }

  static String _translateWordByWord(String text, String sourceLang, String targetLang) {
    final words = text.split(' ');
    final translatedWords = <String>[];
    
    for (final word in words) {
      String translatedWord = word;
      
      // Try to find translation for this word
      if (_staticTranslations.containsKey(targetLang) && 
          _staticTranslations[targetLang]!.containsKey(word)) {
        translatedWord = _staticTranslations[targetLang]![word]!;
      }
      
      translatedWords.add(translatedWord);
    }
    
    return translatedWords.join(' ');
  }

  static List<String> getSupportedLanguages() {
    return _staticTranslations.keys.toList();
  }

  static String getLanguageName(String code) {
    final languageNames = {
      'en': 'English',
      'es': 'Spanish',
      'fr': 'French',
      'ar': 'Arabic',
      'zh': 'Chinese',
    };
    
    return languageNames[code] ?? code.toUpperCase();
  }
} 