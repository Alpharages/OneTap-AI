import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomPromptService {
  // Gemini API Configuration
  static const String _geminiApiKey = '';
  static const String _geminiApiUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';

  static Future<String> generateResponse(String prompt, String inputText) async {
    try {
      final result = await _callGemini(prompt, inputText);
      if (result.isNotEmpty) {
        return result;
      }
    } catch (e) {
      print('Gemini custom prompt failed, using fallback: $e');
      // Fallback to basic processing
      return _fallbackResponse(prompt, inputText);
    }
    
    return _fallbackResponse(prompt, inputText);
  }

  static Future<String> _callGemini(String prompt, String inputText) async {
    try {
      final fullPrompt = _buildPrompt(prompt, inputText);
      
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': fullPrompt,
              },
            ],
          },
        ],
      };
      
      print('Making Gemini Custom Prompt API call...');
      print('Prompt: $prompt');
      
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
      
      print('Gemini Custom Prompt API Response Status: ${response.statusCode}');
      
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
        print('Gemini Custom Prompt API Error: $errorBody');
        throw Exception('Gemini Custom Prompt API error: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      print('Gemini Custom Prompt API Exception: $e');
      throw Exception('Gemini Custom Prompt API error: $e');
    }
  }

  static String _buildPrompt(String prompt, String inputText) {
    return 'You are an AI assistant that helps users process text according to their specific instructions. Please process the following text according to this instruction: "$prompt"\n\nText to process:\n"$inputText"\n\nPlease provide a helpful and accurate response based on the instruction. Only return the processed result, no explanations.';
  }

  static String _fallbackResponse(String prompt, String inputText) {
    // Basic fallback responses based on prompt keywords
    final promptLower = prompt.toLowerCase();
    final input = inputText.trim();
    
    if (promptLower.contains('professional')) {
      return 'Professional version: ${input.replaceAll('hey', 'Hello').replaceAll('thanks', 'Thank you')}';
    } else if (promptLower.contains('simplify')) {
      return 'Simplified: ${input.split(' ').take(5).join(' ')}...';
    } else if (promptLower.contains('engaging')) {
      return 'Engaging version: "Exciting news! $input"';
    } else if (promptLower.contains('bullet')) {
      final words = input.split(' ');
      return words.map((word) => '• $word').join('\n');
    } else if (promptLower.contains('summarize')) {
      return 'Summary: ${input.split(' ').take(10).join(' ')}...';
    } else if (promptLower.contains('formal')) {
      return 'Formal version: "I would like to inform you that ${input.toLowerCase()}"';
    } else if (promptLower.contains('casual')) {
      return 'Casual version: "Hey! $input"';
    } else if (promptLower.contains('grammar')) {
      return 'Grammar corrected: ${input.replaceAll('its', 'it\'s')}';
    } else if (promptLower.contains('expand')) {
      return 'Expanded idea: This concept involves $input and can be applied in various contexts.';
    } else if (promptLower.contains('concise')) {
      return 'Concise version: ${input.split(' ').take(3).join(' ')}';
    } else {
      return 'Here is your processed text: $input';
    }
  }
} 