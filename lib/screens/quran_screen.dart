import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import '../models/quran_verse.dart';
import '../services/quran_service.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List<QuranVerse> _verses = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _aiExplanation = '';
  bool _showExplanation = false;
  bool _isLoadingExplanation = false;

  @override
  void initState() {
    super.initState();
    _loadVerses();
  }

  Future<void> _loadVerses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final verses = await QuranService.getVerses();
      setState(() {
        _verses = verses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading verses: $e')),
      );
    }
  }

  Future<void> _searchVerses(String query) async {
    if (query.isEmpty) {
      _loadVerses();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final verses = await QuranService.searchVerses(query);
      setState(() {
        _verses = verses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching verses: $e')),
      );
    }
  }

  void _playPronunciation(String arabicText) {
    // TODO: Implement audio playback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing pronunciation for: $arabicText'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _getAIExplanation(QuranVerse verse) async {
    setState(() {
      _isLoadingExplanation = true;
    });

    try {
      final explanation = await QuranService.getVerseExplanation(verse);
      setState(() {
        _aiExplanation = explanation;
        _showExplanation = true;
        _isLoadingExplanation = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingExplanation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting explanation: $e')),
      );
    }
  }

  void _copyVerse(QuranVerse verse) {
    final verseText = 'Surah ${verse.surahNumber}, Verse ${verse.verseNumber}\n\n${verse.arabicText}\n\n${verse.transliteration}\n\n${verse.translation}';
    FlutterClipboard.copy(verseText).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verse copied to clipboard'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Mode'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          Icon(
            Icons.auto_awesome,
            color: Colors.yellow,
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              // TODO: Show surah selection
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Surah selection coming soon!')),
              );
            },
            icon: const Icon(Icons.menu_book),
            tooltip: 'Select Surah',
          ),
        ],
      ),
      body: Column(
        children: [
          // Gemini AI Status Card
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Powered by Google Gemini AI',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'AI-powered verse explanations and guidance',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _searchVerses(value);
              },
              decoration: InputDecoration(
                hintText: 'Search verses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _verses.isEmpty
                    ? const Center(
                        child: Text(
                          'No verses found',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _verses.length,
                        itemBuilder: (context, index) {
                          final verse = _verses[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Surah ${verse.surahNumber}, Verse ${verse.verseNumber}',
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () => _getAIExplanation(verse),
                                            icon: _isLoadingExplanation 
                                                ? const SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child: CircularProgressIndicator(strokeWidth: 2),
                                                  )
                                                : const Icon(Icons.psychology),
                                            tooltip: 'AI Explanation',
                                          ),
                                          IconButton(
                                            onPressed: () => _copyVerse(verse),
                                            icon: const Icon(Icons.copy),
                                            tooltip: 'Copy verse',
                                          ),
                                          IconButton(
                                            onPressed: () => _playPronunciation(verse.arabicText),
                                            icon: const Icon(Icons.volume_up),
                                            tooltip: 'Play pronunciation',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: () => _playPronunciation(verse.arabicText),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.orange.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Text(
                                        verse.arabicText,
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontSize: 18,
                                          height: 1.8,
                                          fontFamily: 'Arial', // Better Arabic font support
                                        ),
                                        textAlign: TextAlign.right,
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    verse.transliteration,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    verse.translation,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  if (_showExplanation && _aiExplanation.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.green.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.auto_awesome,
                                                color: Colors.green,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'AI Explanation',
                                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            _aiExplanation,
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
} 