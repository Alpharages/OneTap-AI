import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/text_rewrite_request.dart';

class TextRewriteService {
  // Gemini API Configuration
  static const String _geminiApiKey = '';
  static const String _geminiApiUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';
  
  // Check if Gemini is available
  static bool get isGeminiAvailable => true;

  static Future<String> rewriteText(TextRewriteRequest request) async {
    try {
      final result = await _callGemini(request);
      if (result.isNotEmpty) {
        return result;
      }
    } catch (e) {
      print('Gemini AI failed, providing fallback response: $e');
      // Provide a simple fallback response based on tone
      return _getFallbackResponse(request.originalText, request.tone);
    }
    
    throw Exception('Unable to process your request. Please try again.');
  }

  static String _getFallbackResponse(String originalText, String tone) {
    if (originalText.trim().isEmpty) {
      return originalText;
    }
    
    switch (tone.toLowerCase()) {
      case 'professional':
        return 'I apologize, but I am currently unable to process your request through the AI service. Please try again later. Your original text was: "$originalText"';
      case 'casual':
        return 'Sorry, the AI is having trouble right now. Try again in a bit! Your text was: "$originalText"';
      case 'formal':
        return 'I regret to inform you that the AI service is temporarily unavailable. Please attempt your request again at a later time. Your original text was: "$originalText"';
      default:
        return 'The AI service is currently unavailable. Please try again later. Your text: "$originalText"';
    }
  }

  static Future<String> _callGemini(TextRewriteRequest request) async {
    try {
      final prompt = _buildPrompt(request.originalText, request.tone);
      
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
      
      print('Making Gemini API call...');


      print('URL: $_geminiApiUrl?key=$_geminiApiKey');
      print('Request Body: ${jsonEncode(requestBody)}');
      
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
      
      print('Gemini API Response Status: ${response.statusCode}');
      print('Gemini API Response Body: ${response.body}');
      
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
        
        // If we get here, the response structure is unexpected
        throw Exception('Unexpected response structure from Gemini API');
      } else {
        final errorBody = response.body;
        print('Gemini API Error: $errorBody');
        throw Exception('Gemini API error: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      print('Gemini API Exception: $e');
      throw Exception('Gemini API error: $e');
    }
  }

  static String _buildPrompt(String text, String tone) {
    switch (tone.toLowerCase()) {
      case 'professional':
        return 'Rewrite this text in a professional, business-appropriate tone suitable for workplace communication. Maintain the original meaning while making it more formal and polished. Only return the rewritten text, no explanations:\n\n"$text"';
      case 'casual':
        return 'Rewrite this text in a casual, friendly tone suitable for informal communication with friends or colleagues. Make it more conversational and relaxed. Only return the rewritten text, no explanations:\n\n"$text"';
      case 'formal':
        return 'Rewrite this text in a very formal, academic tone suitable for official documents or academic writing. Use sophisticated language and proper structure. Only return the rewritten text, no explanations:\n\n"$text"';
      default:
        return 'Rewrite this text in a professional tone. Only return the rewritten text, no explanations:\n\n"$text"';
    }
  }


} 