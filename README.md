# Promptly - AI-Powered Productivity App

Promptly is a Flutter-based mobile application that integrates AI-powered tools to enhance user productivity and accessibility. The app provides professional text rewriting, real-time translation, Quranic pronunciation, and custom prompting capabilities.

## Features

### 🎯 Professional Rewriting
- **AI-Powered Text Transformation** using Google Gemini AI
- **Multiple Tones**: Professional, Casual, Formal
- **Real-time Processing** with intelligent prompts
- **Ready to Use** - No API key configuration required
- **Pure AI Solution** - No local fallback, 100% AI-powered

#### Google Gemini AI Integration
The Professional Rewriting feature uses Google's advanced Gemini AI model for superior text transformation:

**Features:**
- **Smart Context Understanding** - AI understands meaning, not just words
- **Professional Quality** - Real business-appropriate transformations
- **Pure AI Processing** - All text transformations handled by Gemini AI
- **Cost-Effective** - Powered by Google's advanced AI technology
- **No Setup Required** - Works out of the box

### 🌐 Real-Time Translation
- **AI-Powered Translation** using Google Gemini AI
- Auto-detect source language
- Support for multiple languages: English, Spanish, French, Arabic, Chinese
- Language swap functionality for quick translations
- **Pure AI Solution** - All translations handled by Gemini AI

### 📖 Quran Mode
- Tap on Arabic text to hear correct Quranic recitation
- Tajweed-aware pronunciation for accurate learning
- Browse Quranic verses with transliteration and translation
- Search functionality for finding specific verses
- Ideal for Muslims and Arabic learners

### 🧠 Custom Prompts
- Enter custom prompts for AI-generated responses
- Pre-built suggested prompts for common use cases
- Instant processing with mock AI responses
- Copy-to-clipboard functionality

### 📱 Text Selection Overlay (Coming Soon)
- Floating action button for text selection
- Cross-app text processing capabilities
- Quick access to AI tools from any app

## Technology Stack

- **Framework**: Flutter 3.4.0+
- **Language**: Dart
- **State Management**: Provider
- **HTTP Requests**: http package
- **AI Integration**: Google Gemini AI
- **Text-to-Speech**: flutter_tts
- **Audio Playback**: audioplayers
- **Local Storage**: shared_preferences
- **Permissions**: permission_handler

## Getting Started

### Prerequisites
- Flutter SDK (3.4.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)
- Google Gemini AI (included, no setup required)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd promptly
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform Support
- ✅ Android
- ✅ iOS
- ✅ Web (basic support)
- ✅ Desktop (basic support)

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── text_rewrite_request.dart
│   ├── translation_request.dart
│   └── quran_verse.dart
├── services/                 # Business logic
│   ├── text_rewrite_service.dart  # Google Gemini AI only
│   ├── translation_service.dart
│   └── quran_service.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── text_rewrite_screen.dart   # AI-powered text rewriting
│   ├── translation_screen.dart
│   ├── quran_screen.dart
│   └── custom_prompt_screen.dart
└── widgets/                  # Reusable UI components

assets/
├── audio/                   # Audio files for Quranic recitation
├── images/                  # App images and icons
└── data/                    # Static data files
    └── sample_verses.json
```

## Usage Guide

### Professional Rewriting (AI-Powered)
1. Navigate to "Professional Rewriting" from the home screen
2. Select the desired tone (professional, casual, formal)
3. Enter your text in the input field
4. Tap "Rewrite Text" to process
5. Copy the rewritten text using the copy button

**AI-Powered Processing:**
- **100% AI**: All text transformations handled by Google Gemini AI
- **No Fallback**: Pure AI solution for superior quality
- **Real-time**: Instant processing with intelligent context understanding

### Translation (AI-Powered)
1. Open the "Translation" screen
2. Select source and target languages
3. Enter text to translate
4. Use the swap button to quickly switch languages
5. View and copy the AI-translated result

**AI-Powered Processing:**
- **100% AI**: All translations handled by Google Gemini AI
- **No Fallback**: Pure AI solution for superior quality
- **Real-time**: Instant processing with intelligent context understanding

### Quran Mode
1. Access "Quran Mode" from the home screen
2. Browse through available verses
3. Tap on Arabic text to hear pronunciation
4. Use the search function to find specific verses
5. View transliteration and translation for each verse

### Custom Prompts
1. Go to "Custom Prompts" screen
2. Choose from suggested prompts or enter your own
3. Input the text you want to process
4. Generate AI-powered responses
5. Copy results to clipboard

## Development Notes

### AI Integration Implementation
The app features a pure AI approach for text rewriting:

- **Google Gemini AI**: 100% AI-powered transformation
- **No Local Processing**: All transformations handled by AI
- **Superior Quality**: Context-aware, intelligent text rewriting
- **No Configuration**: Ready to use out of the box

### Static Data Implementation
The app currently uses static data for some AI-driven features to enable testing and development without external API dependencies. This includes:

- **Translation**: Static translation mappings for common phrases
- **Quranic Pronunciation**: Mock audio URLs and verse data
- **Custom Prompts**: Pre-built response patterns based on prompt keywords

### Future Enhancements
- Enhanced Google Gemini AI integration with more models
- Google Translate API for live translation services
- Text-to-speech API integration for Quranic pronunciation
- Text selection overlay implementation
- User authentication and settings
- Offline mode support
- Advanced audio controls for Quranic recitation

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the repository or contact the development team.

---

**Note**: This app uses pure AI-powered text processing with Google Gemini AI. All text transformations are handled by the advanced AI model, providing superior quality and context-aware results. No local processing or fallback systems are used.
