import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quran_verse.dart';

class QuranService {
  // Gemini API Configuration
  static const String _geminiApiKey = '';
  static const String _geminiApiUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';
  // Static data for testing - in production this would fetch from Quran API
  static final List<QuranVerse> _staticVerses = [
    QuranVerse(
      surahNumber: 1,
      verseNumber: 1,
      arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      transliteration: 'Bismillahi ar-rahmani ar-raheem',
      translation: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
      audioUrl: 'assets/audio/fatiha_1.mp3',
    ),
    QuranVerse(
      surahNumber: 1,
      verseNumber: 2,
      arabicText: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
      transliteration: 'Al-hamdu lillahi rabbi al-alameen',
      translation: 'All praise is due to Allah, Lord of the worlds.',
      audioUrl: 'assets/audio/fatiha_2.mp3',
    ),
    QuranVerse(
      surahNumber: 1,
      verseNumber: 3,
      arabicText: 'الرَّحْمَٰنِ الرَّحِيمِ',
      transliteration: 'Ar-rahmani ar-raheem',
      translation: 'The Entirely Merciful, the Especially Merciful.',
      audioUrl: 'assets/audio/fatiha_3.mp3',
    ),
    QuranVerse(
      surahNumber: 1,
      verseNumber: 4,
      arabicText: 'مَالِكِ يَوْمِ الدِّينِ',
      transliteration: 'Maliki yawmi ad-deen',
      translation: 'Sovereign of the Day of Recompense.',
      audioUrl: 'assets/audio/fatiha_4.mp3',
    ),
    QuranVerse(
      surahNumber: 1,
      verseNumber: 5,
      arabicText: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
      transliteration: 'Iyyaka na\'budu wa iyyaka nasta\'een',
      translation: 'It is You we worship and You we ask for help.',
      audioUrl: 'assets/audio/fatiha_5.mp3',
    ),
    QuranVerse(
      surahNumber: 1,
      verseNumber: 6,
      arabicText: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
      transliteration: 'Ihdina as-sirata al-mustaqeem',
      translation: 'Guide us to the straight path.',
      audioUrl: 'assets/audio/fatiha_6.mp3',
    ),
    QuranVerse(
      surahNumber: 1,
      verseNumber: 7,
      arabicText: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
      transliteration: 'Sirata allatheena an\'amta alayhim ghayri al-maghdoobi alayhim wa la ad-dalleen',
      translation: 'The path of those upon whom You have bestowed favor, not of those who have evoked Your anger or of those who are astray.',
      audioUrl: 'assets/audio/fatiha_7.mp3',
    ),
  ];

  static Future<List<QuranVerse>> getVerses({int? surahNumber}) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (surahNumber != null) {
      return _staticVerses.where((verse) => verse.surahNumber == surahNumber).toList();
    }
    
    return _staticVerses;
  }

  static Future<QuranVerse?> getVerse(int surahNumber, int verseNumber) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      return _staticVerses.firstWhere(
        (verse) => verse.surahNumber == surahNumber && verse.verseNumber == verseNumber,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<List<QuranVerse>> searchVerses(String query) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    final lowercaseQuery = query.toLowerCase();
    return _staticVerses.where((verse) {
      return verse.arabicText.contains(query) ||
             verse.transliteration.toLowerCase().contains(lowercaseQuery) ||
             verse.translation.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  static Future<String> getPronunciation(String arabicText) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 150));
    
    // In a real implementation, this would call a TTS API
    // For now, return a mock audio URL
    return 'assets/audio/pronunciation_${arabicText.hashCode}.mp3';
  }

  static List<String> getSurahNames() {
    return [
      'Al-Fatiha (The Opening)',
      'Al-Baqarah (The Cow)',
      'Aal-Imran (The Family of Imran)',
      'An-Nisa (The Women)',
      'Al-Ma\'idah (The Table Spread)',
    ];
  }

  // AI-Powered Methods
  static Future<String> getVerseExplanation(QuranVerse verse) async {
    try {
      final result = await _callGeminiExplanation(verse);
      if (result.isNotEmpty) {
        return result;
      }
    } catch (e) {
      print('Gemini verse explanation failed, using fallback: $e');
      return _fallbackExplanation(verse);
    }
    
    return _fallbackExplanation(verse);
  }

  static Future<String> getVerseRecommendations(String theme) async {
    try {
      final result = await _callGeminiRecommendations(theme);
      if (result.isNotEmpty) {
        return result;
      }
    } catch (e) {
      print('Gemini verse recommendations failed, using fallback: $e');
      return _fallbackRecommendations(theme);
    }
    
    return _fallbackRecommendations(theme);
  }

  static Future<String> getPronunciationGuide(String arabicText) async {
    try {
      final result = await _callGeminiPronunciationGuide(arabicText);
      if (result.isNotEmpty) {
        return result;
      }
    } catch (e) {
      print('Gemini pronunciation guide failed, using fallback: $e');
      return _fallbackPronunciationGuide(arabicText);
    }
    
    return _fallbackPronunciationGuide(arabicText);
  }

  static Future<String> _callGeminiExplanation(QuranVerse verse) async {
    try {
      final prompt = _buildExplanationPrompt(verse);
      
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
      
      print('Making Gemini Quran Explanation API call...');
      print('Explaining Surah ${verse.surahNumber}, Verse ${verse.verseNumber}');
      
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
      
      print('Gemini Quran Explanation API Response Status: ${response.statusCode}');
      
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
        print('Gemini Quran Explanation API Error: $errorBody');
        throw Exception('Gemini Quran Explanation API error: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      print('Gemini Quran Explanation API Exception: $e');
      throw Exception('Gemini Quran Explanation API error: $e');
    }
  }

  static Future<String> _callGeminiRecommendations(String theme) async {
    try {
      final prompt = _buildRecommendationsPrompt(theme);
      
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
      
      print('Making Gemini Quran Recommendations API call...');
      print('Theme: $theme');
      
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
        print('Gemini Quran Recommendations API Error: $errorBody');
        throw Exception('Gemini Quran Recommendations API error: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      print('Gemini Quran Recommendations API Exception: $e');
      throw Exception('Gemini Quran Recommendations API error: $e');
    }
  }

  static Future<String> _callGeminiPronunciationGuide(String arabicText) async {
    try {
      final prompt = _buildPronunciationGuidePrompt(arabicText);
      
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
      
      print('Making Gemini Quran Pronunciation Guide API call...');
      
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
        print('Gemini Quran Pronunciation Guide API Error: $errorBody');
        throw Exception('Gemini Quran Pronunciation Guide API error: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      print('Gemini Quran Pronunciation Guide API Exception: $e');
      throw Exception('Gemini Quran Pronunciation Guide API error: $e');
    }
  }

  static String _buildExplanationPrompt(QuranVerse verse) {
    return 'Please provide a brief and respectful explanation of this Quranic verse:\n\nArabic: ${verse.arabicText}\nTransliteration: ${verse.transliteration}\nTranslation: ${verse.translation}\n\nSurah ${verse.surahNumber}, Verse ${verse.verseNumber}\n\nPlease provide a concise explanation focusing on the meaning and significance.';
  }

  static String _buildRecommendationsPrompt(String theme) {
    return 'Please suggest some Quranic verses related to the theme: "$theme". Provide a brief explanation of why each verse is relevant to this theme. Focus on verses that offer guidance, comfort, or wisdom related to this topic.';
  }

  static String _buildPronunciationGuidePrompt(String arabicText) {
    return 'Please provide a pronunciation guide for this Arabic text from the Quran:\n\n"$arabicText"\n\nProvide a detailed breakdown of how to pronounce each word correctly, including any special rules for Quranic recitation (tajweed).';
  }

  static String _fallbackExplanation(QuranVerse verse) {
    return 'This verse from Surah ${verse.surahNumber} teaches us about ${verse.translation.toLowerCase()}. It reminds us of the importance of faith and guidance in our daily lives.';
  }

  static String _fallbackRecommendations(String theme) {
    return 'For the theme "$theme", consider reading verses about patience, gratitude, and seeking guidance. These verses often provide comfort and wisdom for various life situations.';
  }

  static String _fallbackPronunciationGuide(String arabicText) {
    return 'To pronounce this verse correctly, focus on clear articulation of each letter and follow the rules of tajweed (proper Quranic recitation). Practice slowly and with proper breath control.';
  }
} 