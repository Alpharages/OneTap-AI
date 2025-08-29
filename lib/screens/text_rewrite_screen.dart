import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import '../models/text_rewrite_request.dart';
import '../services/text_rewrite_service.dart';

class TextRewriteScreen extends StatefulWidget {
  const TextRewriteScreen({super.key});

  @override
  State<TextRewriteScreen> createState() => _TextRewriteScreenState();
}

class _TextRewriteScreenState extends State<TextRewriteScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedTone = 'professional';
  String _rewrittenText = '';
  bool _isLoading = false;
  bool _mounted = true;

  final List<String> _tones = [
    'professional',
    'casual',
    'formal',
  ];

  @override
  void dispose() {
    _mounted = false;
    _textController.dispose();
    super.dispose();
  }

  Future<void> _rewriteText() async {
    if (!_mounted) return;
    
    if (_textController.text.trim().isEmpty) {
      if (_mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter some text to rewrite')),
        );
      }
      return;
    }

    if (_mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final request = TextRewriteRequest(
        originalText: _textController.text.trim(),
        tone: _selectedTone,
      );

      final result = await TextRewriteService.rewriteText(request);

      if (_mounted) {
        setState(() {
          _rewrittenText = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (_mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Rewriting'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          Icon(
            Icons.auto_awesome,
            color: Colors.yellow,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gemini AI Status Card
            Card(
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
                            'Advanced AI-powered text rewriting',
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
            const SizedBox(height: 16),
            
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Tone',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedTone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tone',
                      ),
                      items: _tones.map((tone) {
                        return DropdownMenuItem(
                          value: tone,
                          child: Text(tone.capitalize()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTone = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Original Text',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _textController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter text to rewrite...',
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _rewriteText,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.edit),
                        label: Text(_isLoading ? 'Rewriting...' : 'Rewrite Text'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_rewrittenText.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rewritten Text',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          IconButton(
                            onPressed: () {
                              FlutterClipboard.copy(_rewrittenText).then((value) {
                                if (_mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Copied to clipboard'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              });
                            },
                            icon: const Icon(Icons.copy),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _rewrittenText,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
