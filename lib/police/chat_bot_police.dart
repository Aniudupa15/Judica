// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_tts/flutter_tts.dart';
//
// import '../common_pages/lawgpt_service.dart';
//
// class ChatScreenPolice extends StatefulWidget {
//   const ChatScreenPolice({super.key});
//
//   @override
//   _ChatScreenPoliceState createState() => _ChatScreenPoliceState();
// }
//
// class _ChatScreenPoliceState extends State<ChatScreenPolice> {
//   final LawGPTService service = LawGPTService();
//   final TextEditingController controller = TextEditingController();
//   bool isLoading = false;
//   List<Map<String, String>> chatHistory = [];
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;
//   bool isSpeaking = false;
//   String _selectedLanguage = 'en-IN';
//   final FlutterTts flutterTts = FlutterTts();
//
//   final Map<String, String> indianLanguages = {
//     'English (India)': 'en-IN',
//     'Hindi (India)': 'hi-IN',
//     'Bengali (India)': 'bn-IN',
//     'Telugu (India)': 'te-IN',
//     'Marathi (India)': 'mr-IN',
//     'Tamil (India)': 'ta-IN',
//     'Urdu (India)': 'ur-IN',
//     'Gujarati (India)': 'gu-IN',
//     'Kannada (India)': 'kn-IN',
//     'Malayalam (India)': 'ml-IN',
//     'Punjabi (India)': 'pa-IN',
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     _loadChatHistory();
//     _initSpeech();
//     _initTts();
//     _setupTtsListeners();
//   }
//
//   @override
//   void dispose() {
//     flutterTts.stop();
//     controller.dispose();
//     super.dispose();
//   }
//
//   void _setupTtsListeners() {
//     flutterTts.setStartHandler(() {
//       setState(() {
//         isSpeaking = true;
//       });
//     });
//
//     flutterTts.setCompletionHandler(() {
//       setState(() {
//         isSpeaking = false;
//       });
//     });
//
//     flutterTts.setErrorHandler((msg) {
//       setState(() {
//         isSpeaking = false;
//       });
//     });
//   }
//
//   Future<void> _loadChatHistory() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? savedHistory = prefs.getString('chat_history');
//     if (savedHistory != null) {
//       final List<dynamic> decodedHistory = json.decode(savedHistory);
//       setState(() {
//         chatHistory = decodedHistory
//             .map((item) => Map<String, String>.from(item))
//             .toList();
//       });
//     }
//   }
//
//   Future<void> _saveChatHistory() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String encodedHistory = json.encode(chatHistory);
//     await prefs.setString('chat_history', encodedHistory);
//   }
//
//   void askQuestion() async {
//     if (controller.text.trim().isEmpty) return;
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       final question = controller.text;
//       final answer = await service.askQuestion(
//         question,
//         chatHistory.map((entry) => entry["question"] ?? '').toList(),
//       );
//
//       setState(() {
//         chatHistory.add({"question": question, "answer": answer});
//       });
//       controller.clear();
//       await _saveChatHistory();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: $e")));
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   void deleteMessage(int index) async {
//     setState(() {
//       chatHistory.removeAt(index);
//     });
//     await _saveChatHistory();
//   }
//
//   void shareMessage(int index) {
//     final entry = chatHistory[index];
//     final message = "You: ${entry['question'] ?? 'No Question'}\nLawGPT: ${entry['answer'] ?? 'No Answer'}";
//     Share.share(message);
//   }
//
//   void _initSpeech() async {
//     try {
//       bool available = await _speech.initialize();
//       if (!available) {
//         setState(() {
//         });
//       }
//     } catch (e) {
//       setState(() {
//       });
//     }
//   }
//
//   void _toggleListening() async {
//     if (!_isListening) {
//       bool available = await _speech.listen(
//         onResult: (result) {
//           setState(() {
//             controller.text = result.recognizedWords;
//           });
//         },
//         localeId: _selectedLanguage,
//       );
//
//       if (available) {
//         setState(() {
//           _isListening = true;
//         });
//       } else {
//         setState(() {
//         });
//       }
//     } else {
//       await _speech.stop();
//       setState(() {
//         _isListening = false;
//       });
//     }
//   }
//
//   void _initTts() async {
//     try {
//       await flutterTts.setLanguage(_selectedLanguage);
//       await flutterTts.setSpeechRate(0.5);
//       await flutterTts.setVolume(1.0);
//       await flutterTts.setPitch(1.0);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to initialize TTS: $e")));
//     }
//   }
//
//   Future<void> _speak(String text) async {
//     if (text.isEmpty) return;
//
//     if (isSpeaking) {
//       await _stopSpeaking();
//       return;
//     }
//
//     try {
//       await flutterTts.setLanguage(_selectedLanguage);
//       await flutterTts.speak(text);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to speak: $e")));
//     }
//   }
//
//   Future<void> _stopSpeaking() async {
//     await flutterTts.stop();
//     setState(() {
//       isSpeaking = false;
//     });
//   }
//
//   TextStyle getFontStyleForLanguage(String languageCode) {
//     switch (languageCode) {
//       case 'hi-IN':
//         return GoogleFonts.notoSansDevanagari();
//       case 'bn-IN':
//         return GoogleFonts.notoSansBengali();
//       case 'te-IN':
//         return GoogleFonts.notoSansTelugu();
//       case 'mr-IN':
//         return GoogleFonts.notoSansDevanagari();
//       case 'ta-IN':
//         return GoogleFonts.notoSansTamil();
//       case 'ur-IN':
//         return GoogleFonts.notoNastaliqUrdu();
//       case 'gu-IN':
//         return GoogleFonts.notoSansGujarati();
//       case 'kn-IN':
//         return GoogleFonts.notoSansKannada();
//       case 'ml-IN':
//         return GoogleFonts.notoSansMalayalam();
//       case 'pa-IN':
//         return GoogleFonts.notoSansGurmukhi();
//       default:
//         return GoogleFonts.roboto();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/ChatBotBackground.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: DropdownButton<String>(
//                   value: _selectedLanguage,
//                   onChanged: (String? newValue) {
//                     if (newValue != null) {
//                       setState(() {
//                         _selectedLanguage = newValue;
//                       });
//                       _initTts();
//                     }
//                   },
//                   items: indianLanguages.entries.map((entry) {
//                     return DropdownMenuItem<String>(
//                       value: entry.value,
//                       child: Text(entry.key),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: chatHistory.length,
//                   itemBuilder: (context, index) {
//                     final entry = chatHistory[index];
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ListTile(
//                           title: Text(
//                             "You: ${entry['question'] ?? 'No Question'}",
//                             style: getFontStyleForLanguage(_selectedLanguage).copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                           tileColor: Colors.grey[300]?.withOpacity(0.8),
//                           trailing: PopupMenuButton<String>(
//                             onSelected: (value) {
//                               if (value == 'delete') {
//                                 deleteMessage(index);
//                               } else if (value == 'share') {
//                                 shareMessage(index);
//                               } else if (value == 'speak') {
//                                 _speak(entry['answer'] ?? '');
//                               }
//                             },
//                             itemBuilder: (BuildContext context) => [
//                               const PopupMenuItem<String>(
//                                 value: 'delete',
//                                 child: Text('Delete Message'),
//                               ),
//                               const PopupMenuItem<String>(
//                                 value: 'share',
//                                 child: Text('Share'),
//                               ),
//                               const PopupMenuItem<String>(
//                                 value: 'speak',
//                                 child: Text('Speak'),
//                               ),
//                             ],
//                           ),
//                         ),
//                         ListTile(
//                           title: Text(
//                             "LawGPT: ${entry['answer'] ?? 'No Answer'}",
//                             style: getFontStyleForLanguage(_selectedLanguage).copyWith(
//                               color: Colors.black,
//                             ),
//                           ),
//                           tileColor: Colors.white.withOpacity(0.8),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: Icon(
//                                   isSpeaking ? Icons.stop_circle : Icons.volume_up,
//                                   color: isSpeaking ? Colors.red : null,
//                                 ),
//                                 onPressed: () {
//                                   _speak(entry['answer'] ?? '');
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               if (isLoading)
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: CircularProgressIndicator(),
//                 ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: controller,
//                         decoration: InputDecoration(
//                           hintText: "Ask a question...",
//                           filled: true,
//                           fillColor: Colors.white.withOpacity(0.8),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         style: getFontStyleForLanguage(_selectedLanguage),
//                         onChanged: (text) {
//                           setState(() {});
//                         },
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
//                       color: _isListening ? Colors.red : Colors.grey,
//                       onPressed: _toggleListening,
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.send),
//                       color: controller.text.isNotEmpty
//                           ? Theme.of(context).primaryColor
//                           : Colors.grey,
//                       onPressed: controller.text.isNotEmpty ? askQuestion : null,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//


import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../common_pages/lawgpt_service.dart';

class ChatScreenPolice extends StatefulWidget {
  final VoidCallback? onNavigateToChat;

  const ChatScreenPolice({super.key, this.onNavigateToChat});

  @override
  _ChatScreenPoliceState createState() => _ChatScreenPoliceState();
}

class _ChatScreenPoliceState extends State<ChatScreenPolice> with TickerProviderStateMixin {
  final LawGPTService service = LawGPTService();
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool isLoading = false;
  List<Map<String, String>> chatHistory = [];
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool isSpeaking = false;
  int? currentSpeakingIndex; // Track which message is being spoken
  String _selectedLanguage = 'en-IN';
  final FlutterTts flutterTts = FlutterTts();
  bool _showLanguageSelector = false;

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
    _initTts();
    _setupTtsListeners();
  }

  @override
  void dispose() {
    flutterTts.stop();
    controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
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
        currentSpeakingIndex = null;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isSpeaking = false;
        currentSpeakingIndex = null;
      });
    });
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
      _scrollToBottom();
    }
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedHistory = json.encode(chatHistory);
    await prefs.setString('chat_history', encodedHistory);
  }

  void askQuestion() async {
    if (controller.text.trim().isEmpty) return;

    final question = controller.text;
    controller.clear();
    _focusNode.unfocus();

    setState(() {
      chatHistory.add({"question": question, "answer": "typing"});
      isLoading = true;
    });

    _scrollToBottom();

    try {
      final historyQuestions = chatHistory
          .where((entry) => entry["answer"] != "typing")
          .map((entry) => entry["question"] ?? '')
          .toList();

      final answer = await service.askQuestion(question, historyQuestions);

      setState(() {
        chatHistory[chatHistory.length - 1] = {"question": question, "answer": answer};
        isLoading = false;
      });

      await _saveChatHistory();
      _scrollToBottom();
      _showAdvocateContactDialog();
    } catch (e) {
      setState(() {
        chatHistory.removeLast();
        isLoading = false;
      });
      if (mounted) {
        _showErrorSnackbar("Failed to get answer. Please try again.");
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
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
    Share.share(message, subject: "LawGPT Chat History");
  }

  void _showAdvocateContactDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A5FE8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.gavel, color: Color(0xFF4A5FE8), size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Need Legal Help?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: const Text(
            'Would you like to contact an advocate for personalized legal assistance?',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Not Now',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToAdvocateChat();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A5FE8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              icon: const Icon(Icons.chat, size: 18, color: Colors.white),
              label: const Text('Contact Advocate', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAdvocateChat() {
    if (widget.onNavigateToChat != null) {
      widget.onNavigateToChat!();
    }
  }

  void _initSpeech() async {
    try {
      await _speech.initialize();
    } catch (e) {
      // Handle silently
    }
  }

  void _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.listen(
        onResult: (result) {
          setState(() {
            controller.text = result.recognizedWords;
          });
        },
        localeId: _selectedLanguage,
      );

      if (available) {
        setState(() {
          _isListening = true;
        });
      }
    } else {
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  void _initTts() async {
    try {
      await flutterTts.setLanguage(_selectedLanguage);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
    } catch (e) {
      // Handle silently
    }
  }

  Future<void> _speak(String text, int messageIndex) async {
    if (text.isEmpty) return;

    // If clicking on the same message that's speaking, just stop
    if (isSpeaking && currentSpeakingIndex == messageIndex) {
      await _stopSpeaking();
      return;
    }

    // If speaking a different message, stop it first
    if (isSpeaking) {
      await _stopSpeaking();
      // Add a small delay to ensure TTS has stopped
      await Future.delayed(const Duration(milliseconds: 100));
    }

    try {
      setState(() {
        currentSpeakingIndex = messageIndex;
        isSpeaking = true;
      });
      await flutterTts.setLanguage(_selectedLanguage);
      await flutterTts.speak(text);
    } catch (e) {
      setState(() {
        currentSpeakingIndex = null;
        isSpeaking = false;
      });
    }
  }

  Future<void> _stopSpeaking() async {
    await flutterTts.stop();
    setState(() {
      isSpeaking = false;
      currentSpeakingIndex = null;
    });
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
        return GoogleFonts.inter();
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle currentFontStyle = getFontStyleForLanguage(_selectedLanguage);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: chatHistory.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              itemCount: chatHistory.length,
              reverse: true,
              itemBuilder: (context, index) {
                final reversedIndex = chatHistory.length - 1 - index;
                final entry = chatHistory[reversedIndex];
                return _buildMessageBubble(entry, currentFontStyle, reversedIndex);
              },
            ),
          ),
          _buildInputArea(currentFontStyle),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A5FE8), Color(0xFF6B7FFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A5FE8).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.gavel, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LawGPT Assistant',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Your AI Legal Advisor',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          _buildLanguageButton(),
        ],
      ),
    );
  }

  Widget _buildLanguageButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showLanguageSelector = !_showLanguageSelector;
        });
        if (_showLanguageSelector) {
          _showLanguageBottomSheet();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF4A5FE8).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.language,
          color: Color(0xFF4A5FE8),
          size: 24,
        ),
      ),
    );
  }

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A5FE8).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.language, color: Color(0xFF4A5FE8)),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Select Language',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: indianLanguages.length,
                  itemBuilder: (context, index) {
                    final entry = indianLanguages.entries.elementAt(index);
                    final isSelected = _selectedLanguage == entry.value;
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF4A5FE8).withOpacity(0.1)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          color: isSelected ? const Color(0xFF4A5FE8) : Colors.grey,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        entry.key.split('(').first.trim(),
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? const Color(0xFF4A5FE8) : Colors.black87,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedLanguage = entry.value;
                          _showLanguageSelector = false;
                        });
                        _initTts();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4A5FE8).withOpacity(0.1),
                        const Color(0xFF6B7FFF).withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.gavel,
                    size: 64,
                    color: Color(0xFF4A5FE8),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Welcome to LawGPT',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Ask any legal question and get instant AI-powered answers',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildSuggestionChips(),
        ],
      ),
    );
  }

  Widget _buildSuggestionChips() {
    final suggestions = [
      'Property Rights',
      'Employment Law',
      'Contract Disputes',
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: suggestions.map((suggestion) {
        return GestureDetector(
          onTap: () {
            controller.text = "Tell me about $suggestion";
            askQuestion();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF4A5FE8).withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              suggestion,
              style: const TextStyle(
                color: Color(0xFF4A5FE8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMessageBubble(Map<String, String> entry, TextStyle fontStyle, int index) {
    final String question = entry['question'] ?? 'No Question';
    final String answer = entry['answer'] ?? 'No Answer';
    final bool isTyping = answer == "typing";
    final bool isThisMessageSpeaking = currentSpeakingIndex == index && isSpeaking;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User Message
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8, left: 60),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A5FE8), Color(0xFF6B7FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A5FE8).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                question,
                style: fontStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          // AI Response
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(top: 0, bottom: 8, right: 60),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isTyping)
                    _buildTypingIndicator()
                  else
                    Text(
                      answer,
                      style: fontStyle.copyWith(
                        color: Colors.black87,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  if (!isTyping) ...[
                    const SizedBox(height: 12),
                    _buildMessageActions(entry, index, isThisMessageSpeaking),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(0),
        const SizedBox(width: 4),
        _buildDot(1),
        const SizedBox(width: 4),
        _buildDot(2),
      ],
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 100)),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, -5 * value),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF4A5FE8).withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        setState(() {});
      },
    );
  }

  Widget _buildMessageActions(Map<String, String> entry, int index, bool isThisMessageSpeaking) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: isThisMessageSpeaking ? Icons.stop_circle : Icons.volume_up,
          onPressed: () => _speak(entry['answer'] ?? '', index),
          tooltip: isThisMessageSpeaking ? 'Stop' : 'Listen',
          isActive: isThisMessageSpeaking,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.share_outlined,
          onPressed: () => shareMessage(index),
          tooltip: 'Share',
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.delete_outline,
          onPressed: () => deleteMessage(index),
          tooltip: 'Delete',
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    bool isActive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: isActive ? BoxDecoration(
            color: const Color(0xFF4A5FE8).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ) : null,
          child: Icon(
            icon,
            size: 18,
            color: isActive ? const Color(0xFF4A5FE8) : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(TextStyle fontStyle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: _isListening ? Colors.red : const Color(0xFF4A5FE8),
                    ),
                    onPressed: _toggleListening,
                    tooltip: _isListening ? 'Stop Listening' : 'Voice Input',
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: "Ask your legal question...",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      style: fontStyle.copyWith(color: Colors.black87, fontSize: 15),
                      onChanged: (text) {
                        setState(() {});
                      },
                      onSubmitted: (text) {
                        if (text.isNotEmpty) askQuestion();
                      },
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Material(
              color: controller.text.isNotEmpty
                  ? const Color(0xFF4A5FE8)
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: controller.text.isNotEmpty ? askQuestion : null,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    isLoading ? Icons.stop : Icons.send,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}