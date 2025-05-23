import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool isSpeaking = false;
  String _text = "Tap the microphone to start";
  String _selectedLanguage = 'en-IN';
  final FlutterTts flutterTts = FlutterTts();

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
    _initSpeechWithPermissions();
    _initTts();
    _setupTtsListeners();
  }

  @override
  void dispose() {
    flutterTts.stop();
    controller.dispose();
    super.dispose();
  }

  Future<void> _initSpeechWithPermissions() async {
    try {
      final status = await Permission.microphone.request();

      if (status.isGranted) {
        bool available = await _speech.initialize(
          onStatus: (status) {
            print('Speech recognition status: $status');
            if (status == 'notListening') {
              setState(() {
                _isListening = false;
                _text = "Tap the microphone to start";
              });
            }
          },
          onError: (errorNotification) {
            print('Speech recognition error: $errorNotification');
            setState(() {
              _isListening = false;
              _text = "Error: ${errorNotification.errorMsg}";
            });
          },
        );

        if (!available) {
          setState(() {
            _text = "Speech recognition is not available on this device.";
          });
        }
      } else {
        setState(() {
          _text = "Microphone permission denied. Please enable it in settings.";
        });
        _showPermissionDialog();
      }
    } catch (e) {
      setState(() {
        _text = "Failed to initialize speech recognition: $e";
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Microphone Permission Required'),
        content: const Text(
            'The microphone permission is required for speech recognition. '
                'Please enable it in your device settings to use voice input.'
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
          ),
        ],
      ),
    );
  }

  void _setupTtsListeners() {
    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isSpeaking = false;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  Future<void> _loadChatHistory() async {
    try {
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
    } catch (e) {
      print('Error loading chat history: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load chat history: $e')),
      );
    }
  }

  Future<void> _saveChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedHistory = json.encode(chatHistory);
      await prefs.setString('chat_history', encodedHistory);
    } catch (e) {
      print('Error saving chat history: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save chat history: $e')),
      );
    }
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
        chatHistory.map((entry) => entry["question"] ?? '').toList(),
      );

      setState(() {
        chatHistory.add({"question": question, "answer": answer});
      });
      controller.clear();
      await _saveChatHistory();
      _showAdvocateSuggestions();
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

  void _toggleListening() async {
    if (!_isListening) {
      final status = await Permission.microphone.status;
      if (!status.isGranted) {
        _showPermissionDialog();
        return;
      }

      try {
        bool available = await _speech.listen(
          onResult: (result) {
            setState(() {
              controller.text = result.recognizedWords;
              if (result.finalResult) {
                _isListening = false;
              }
            });
          },
          localeId: _selectedLanguage,
          listenMode: stt.ListenMode.confirmation,
          cancelOnError: true,
          partialResults: true,
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
        );

        if (available) {
          setState(() {
            _isListening = true;
            _text = "Listening...";
          });
        } else {
          setState(() {
            _text = "Speech recognition failed to start";
          });
        }
      } catch (e) {
        setState(() {
          _text = "Error starting speech recognition: $e";
          _isListening = false;
        });
      }
    } else {
      try {
        await _speech.stop();
        setState(() {
          _isListening = false;
          _text = "Tap the microphone to start";
        });
      } catch (e) {
        print("Error stopping speech recognition: $e");
      }
    }
  }

  void _initTts() async {
    try {
      await flutterTts.setLanguage(_selectedLanguage);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to initialize TTS: $e")),
      );
    }
  }

  Future<void> _speak(String text) async {
    if (text.isEmpty) return;

    if (isSpeaking) {
      await _stopSpeaking();
      return;
    }

    try {
      await flutterTts.setLanguage(_selectedLanguage);
      await flutterTts.speak(text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to speak: $e")),
      );
    }
  }

  Future<void> _stopSpeaking() async {
    try {
      await flutterTts.stop();
      setState(() {
        isSpeaking = false;
      });
    } catch (e) {
      print("Error stopping TTS: $e");
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
    final message = "You: ${entry['question'] ?? 'No Question'}\nLawGPT: ${entry['answer'] ?? 'No Answer'}";
    Share.share(message);
  }

  TextStyle getFontStyleForLanguage(String languageCode) {
    switch (languageCode) {
      case 'hi-IN':
        return GoogleFonts.notoSansDevanagari();
      case 'bn-IN':
        return GoogleFonts.notoSansBengali();
      case 'te-IN':
        return GoogleFonts.notoSansTelugu();
      case 'mr-IN':
        return GoogleFonts.notoSansDevanagari();
      case 'ta-IN':
        return GoogleFonts.notoSansTamil();
      case 'ur-IN':
        return GoogleFonts.notoNastaliqUrdu();
      case 'gu-IN':
        return GoogleFonts.notoSansGujarati();
      case 'kn-IN':
        return GoogleFonts.notoSansKannada();
      case 'ml-IN':
        return GoogleFonts.notoSansMalayalam();
      case 'pa-IN':
        return GoogleFonts.notoSansGurmukhi();
      default:
        return GoogleFonts.roboto();
    }
  }

  List<Map<String, String>> _getAdvocateSuggestions() {
    return [
      {
        'name': 'Advocate John Doe',
        'phone': '+91 1234567890',
        'email': 'john.doe@example.com',
      },
      {
        'name': 'Advocate Jane Smith',
        'phone': '+91 9876543210',
        'email': 'jane.smith@example.com',
      },
    ];
  }

  void _showAdvocateSuggestions() {
    final advocates = _getAdvocateSuggestions();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Suggested Advocates'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: advocates.map((advocate) {
              return ListTile(
                title: Text(advocate['name'] ?? ''),
                subtitle: Text('Phone: ${advocate['phone']}\nEmail: ${advocate['email']}'),
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: _selectedLanguage,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedLanguage = newValue;
                      });
                      _initTts();
                    }
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
                            "You: ${entry['question'] ?? 'No Question'}",
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
                                _speak(entry['answer'] ?? '');
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
                              "LawGPT: ${entry['answer'] ?? 'No Answer'}",
                              style: getFontStyleForLanguage(_selectedLanguage).copyWith(
                                color: Colors.black,
                              ),
                            ),
                            tileColor: Colors.white.withOpacity(0.8),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isSpeaking ? Icons.stop_circle : Icons.volume_up,
                                    color: isSpeaking ? Colors.red : null,
                                  ),
                                  onPressed: () {
                                    _speak(entry['answer'] ?? '');
                                  },
                                ),
                              ],
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
                            setState(() {});
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                        color: _isListening ? Colors.red : Colors.grey,
                        onPressed: _toggleListening,
                      ),
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
    }
  }