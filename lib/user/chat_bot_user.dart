import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:flutter_tts/flutter_tts.dart'; // Import FlutterTts

import '../common_pages/lawgpt_service.dart';

class ChatScreenUser extends StatefulWidget {
  const ChatScreenUser({super.key});

  @override
  _ChatScreenUserState createState() => _ChatScreenUserState();
}

class _ChatScreenUserState extends State<ChatScreenUser> {
  final LawGPTService service = LawGPTService();
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;
  List<Map<String, String>> chatHistory = [];
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = "Tap the microphone to start";
  String _selectedLanguage = 'en-IN'; // Default language
  final FlutterTts flutterTts = FlutterTts(); // Initialize FlutterTts

  // List of Indian languages with their locale codes
  final Map<String, String> indianLanguages = {
    'English (India)': 'en-IN',
    'Hindi (India)': 'hi-IN',
    'Bengali (India)': 'bn-IN',
    'Telugu (India)': 'te-IN',
    'Marathi (India)': 'mr-IN',
    'Tamil (India)': 'ta-IN',
    'Urdu (India)': 'ur-IN',
    'Gujarati (India)': 'gu-IN',
    'Kannada (India)': 'kn-IN',
    'Malayalam (India)': 'ml-IN',
    'Punjabi (India)': 'pa-IN',
  };

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
    _initSpeech();
    _initTts(); // Initialize TTS
  }

  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedHistory = prefs.getString('chat_history');
    if (savedHistory != null) {
      final List<dynamic> decodedHistory = json.decode(savedHistory);
      setState(() {
        chatHistory = decodedHistory
            .map((item) => Map<String, String>.from(item))
            .toList();
      });
    }
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedHistory = json.encode(chatHistory);
    prefs.setString('chat_history', encodedHistory);
  }

  void askQuestion() async {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final question = controller.text;
      final answer = await service.askQuestion(
        question,
        chatHistory.map((entry) => entry["question"]!).toList(),
      );

      setState(() {
        chatHistory.add({"question": question, "answer": answer});
      });
      controller.clear();
      await _saveChatHistory();
      _speak(answer); // Speak the answer
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteMessage(int index) async {
    setState(() {
      chatHistory.removeAt(index);
    });
    await _saveChatHistory();
  }

  void shareMessage(int index) {
    final entry = chatHistory[index];
    final message = "You: ${entry['question']}\nLawGPT: ${entry['answer']}";
    Share.share(message);
  }

  void _initSpeech() async {
    bool available = await _speech.initialize();
    if (!available) {
      setState(() {
        _text = "Speech recognition is not available.";
      });
    }
  }

  void _startListening() async {
    if (!_isListening) {
      await _speech.listen(
        onResult: (result) {
          setState(() {
            controller.text = result.recognizedWords;
          });
        },
        localeId: _selectedLanguage, // Set the selected language
      );
      setState(() {
        _isListening = true;
      });
    }
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  // Initialize TTS
  void _initTts() async {
    await flutterTts.setLanguage(_selectedLanguage); // Set the initial language
    await flutterTts.setSpeechRate(0.5); // Adjust speech rate if needed
    await flutterTts.setVolume(1.0); // Set volume
    await flutterTts.setPitch(1.0); // Set pitch
  }

  // Speak the text
  Future<void> _speak(String text) async {
    await flutterTts.setLanguage(_selectedLanguage); // Set language before speaking
    await flutterTts.speak(text);
  }

  // Method to get font style based on selected language
  TextStyle getFontStyleForLanguage(String languageCode) {
    switch (languageCode) {
      case 'hi-IN': // Hindi
        return GoogleFonts.notoSansDevanagari();
      case 'bn-IN': // Bengali
        return GoogleFonts.notoSansBengali();
      case 'te-IN': // Telugu
        return GoogleFonts.notoSansTelugu();
      case 'mr-IN': // Marathi
        return GoogleFonts.notoSansDevanagari();
      case 'ta-IN': // Tamil
        return GoogleFonts.notoSansTamil();
      case 'ur-IN': // Urdu
        return GoogleFonts.notoNastaliqUrdu();
      case 'gu-IN': // Gujarati
        return GoogleFonts.notoSansGujarati();
      case 'kn-IN': // Kannada
        return GoogleFonts.notoSansKannada();
      case 'ml-IN': // Malayalam
        return GoogleFonts.notoSansMalayalam();
      case 'pa-IN': // Punjabi
        return GoogleFonts.notoSansGurmukhi();
      default: // English and others
        return GoogleFonts.roboto();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/ChatBotBackground.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              // Language selection dropdown
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: _selectedLanguage,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });
                    _initTts(); // Reinitialize TTS with the new language
                  },
                  items: indianLanguages.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.value,
                      child: Text(entry.key),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: chatHistory.length,
                  itemBuilder: (context, index) {
                    final entry = chatHistory[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            "You: ${entry['question']}",
                            style: getFontStyleForLanguage(_selectedLanguage).copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          tileColor: Colors.grey[300]?.withOpacity(0.8),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'delete') {
                                deleteMessage(index);
                              } else if (value == 'share') {
                                shareMessage(index);
                              } else if (value == 'speak') {
                                _speak(entry['answer']!); // Speak the answer
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete Message'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'share',
                                child: Text('Share'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'speak',
                                child: Text('Speak'),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "LawGPT: ${entry['answer']}",
                            style: getFontStyleForLanguage(_selectedLanguage).copyWith(
                              color: Colors.black,
                            ),
                          ),
                          tileColor: Colors.white.withOpacity(0.8),
                          trailing: IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () {
                              _speak(entry['answer']!); // Speak the answer
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Ask a question...",
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: getFontStyleForLanguage(_selectedLanguage),
                        onChanged: (text) {
                          // Update the state when text changes
                          setState(() {});
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                      color: Colors.red,
                      onPressed: () {
                        _isListening ? _stopListening() : _startListening();
                      },
                    ),
                    // Send button (only enabled if there is text)
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: controller.text.isNotEmpty
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      onPressed: controller.text.isNotEmpty ? askQuestion : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }}