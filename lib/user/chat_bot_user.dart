// // import 'package:flutter/material.dart';
// // import 'package:share_plus/share_plus.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'dart:convert';
// // import 'package:speech_to_text/speech_to_text.dart' as stt;
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:flutter_tts/flutter_tts.dart';
// // import 'package:permission_handler/permission_handler.dart';
// //
// // import '../common_pages/lawgpt_service.dart';
// //
// // class ChatScreenUser extends StatefulWidget {
// //   const ChatScreenUser({super.key});
// //
// //   @override
// //   _ChatScreenUserState createState() => _ChatScreenUserState();
// // }
// //
// // class _ChatScreenUserState extends State<ChatScreenUser> {
// //   final LawGPTService service = LawGPTService();
// //   final TextEditingController controller = TextEditingController();
// //   bool isLoading = false;
// //   List<Map<String, String>> chatHistory = [];
// //   final stt.SpeechToText _speech = stt.SpeechToText();
// //   bool _isListening = false;
// //   bool isSpeaking = false;
// //   String _text = "Tap the microphone to start";
// //   String _selectedLanguage = 'en-IN';
// //   final FlutterTts flutterTts = FlutterTts();
// //
// //   final Map<String, String> indianLanguages = {
// //     'English (India)': 'en-IN',
// //     'Hindi (India)': 'hi-IN',
// //     'Bengali (India)': 'bn-IN',
// //     'Telugu (India)': 'te-IN',
// //     'Marathi (India)': 'mr-IN',
// //     'Tamil (India)': 'ta-IN',
// //     'Urdu (India)': 'ur-IN',
// //     'Gujarati (India)': 'gu-IN',
// //     'Kannada (India)': 'kn-IN',
// //     'Malayalam (India)': 'ml-IN',
// //     'Punjabi (India)': 'pa-IN',
// //   };
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadChatHistory();
// //     _initSpeechWithPermissions();
// //     _initTts();
// //     _setupTtsListeners();
// //   }
// //
// //   @override
// //   void dispose() {
// //     flutterTts.stop();
// //     controller.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> _initSpeechWithPermissions() async {
// //     try {
// //       final status = await Permission.microphone.request();
// //
// //       if (status.isGranted) {
// //         bool available = await _speech.initialize(
// //           onStatus: (status) {
// //             print('Speech recognition status: $status');
// //             if (status == 'notListening') {
// //               setState(() {
// //                 _isListening = false;
// //                 _text = "Tap the microphone to start";
// //               });
// //             }
// //           },
// //           onError: (errorNotification) {
// //             print('Speech recognition error: $errorNotification');
// //             setState(() {
// //               _isListening = false;
// //               _text = "Error: ${errorNotification.errorMsg}";
// //             });
// //           },
// //         );
// //
// //         if (!available) {
// //           setState(() {
// //             _text = "Speech recognition is not available on this device.";
// //           });
// //         }
// //       } else {
// //         setState(() {
// //           _text = "Microphone permission denied. Please enable it in settings.";
// //         });
// //         _showPermissionDialog();
// //       }
// //     } catch (e) {
// //       setState(() {
// //         _text = "Failed to initialize speech recognition: $e";
// //       });
// //     }
// //   }
// //
// //   void _showPermissionDialog() {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (BuildContext context) => AlertDialog(
// //         title: const Text('Microphone Permission Required'),
// //         content: const Text(
// //             'The microphone permission is required for speech recognition. '
// //                 'Please enable it in your device settings to use voice input.'
// //         ),
// //         actions: [
// //           TextButton(
// //             child: const Text('Cancel'),
// //             onPressed: () => Navigator.of(context).pop(),
// //           ),
// //           TextButton(
// //             child: const Text('Open Settings'),
// //             onPressed: () {
// //               Navigator.of(context).pop();
// //               openAppSettings();
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   void _setupTtsListeners() {
// //     flutterTts.setStartHandler(() {
// //       setState(() {
// //         isSpeaking = true;
// //       });
// //     });
// //
// //     flutterTts.setCompletionHandler(() {
// //       setState(() {
// //         isSpeaking = false;
// //       });
// //     });
// //
// //     flutterTts.setErrorHandler((msg) {
// //       setState(() {
// //         isSpeaking = false;
// //       });
// //     });
// //
// //     flutterTts.setCancelHandler(() {
// //       setState(() {
// //         isSpeaking = false;
// //       });
// //     });
// //   }
// //
// //   Future<void> _loadChatHistory() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       final String? savedHistory = prefs.getString('chat_history');
// //       if (savedHistory != null) {
// //         final List<dynamic> decodedHistory = json.decode(savedHistory);
// //         setState(() {
// //           chatHistory = decodedHistory
// //               .map((item) => Map<String, String>.from(item))
// //               .toList();
// //         });
// //       }
// //     } catch (e) {
// //       print('Error loading chat history: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Failed to load chat history: $e')),
// //       );
// //     }
// //   }
// //
// //   Future<void> _saveChatHistory() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       final String encodedHistory = json.encode(chatHistory);
// //       await prefs.setString('chat_history', encodedHistory);
// //     } catch (e) {
// //       print('Error saving chat history: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Failed to save chat history: $e')),
// //       );
// //     }
// //   }
// //
// //   void askQuestion() async {
// //     if (controller.text.trim().isEmpty) return;
// //
// //     setState(() {
// //       isLoading = true;
// //     });
// //
// //     try {
// //       final question = controller.text;
// //       final answer = await service.askQuestion(
// //         question,
// //         chatHistory.map((entry) => entry["question"] ?? '').toList(),
// //       );
// //
// //       setState(() {
// //         chatHistory.add({"question": question, "answer": answer});
// //       });
// //       controller.clear();
// //       await _saveChatHistory();
// //       _showAdvocateSuggestions();
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Error: $e")),
// //       );
// //     } finally {
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }
// //
// //   void _toggleListening() async {
// //     if (!_isListening) {
// //       final status = await Permission.microphone.status;
// //       if (!status.isGranted) {
// //         _showPermissionDialog();
// //         return;
// //       }
// //
// //       try {
// //         bool available = await _speech.listen(
// //           onResult: (result) {
// //             setState(() {
// //               controller.text = result.recognizedWords;
// //               if (result.finalResult) {
// //                 _isListening = false;
// //               }
// //             });
// //           },
// //           localeId: _selectedLanguage,
// //           listenMode: stt.ListenMode.confirmation,
// //           cancelOnError: true,
// //           partialResults: true,
// //           listenFor: const Duration(seconds: 30),
// //           pauseFor: const Duration(seconds: 3),
// //         );
// //
// //         if (available) {
// //           setState(() {
// //             _isListening = true;
// //             _text = "Listening...";
// //           });
// //         } else {
// //           setState(() {
// //             _text = "Speech recognition failed to start";
// //           });
// //         }
// //       } catch (e) {
// //         setState(() {
// //           _text = "Error starting speech recognition: $e";
// //           _isListening = false;
// //         });
// //       }
// //     } else {
// //       try {
// //         await _speech.stop();
// //         setState(() {
// //           _isListening = false;
// //           _text = "Tap the microphone to start";
// //         });
// //       } catch (e) {
// //         print("Error stopping speech recognition: $e");
// //       }
// //     }
// //   }
// //
// //   void _initTts() async {
// //     try {
// //       await flutterTts.setLanguage(_selectedLanguage);
// //       await flutterTts.setSpeechRate(0.5);
// //       await flutterTts.setVolume(1.0);
// //       await flutterTts.setPitch(1.0);
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Failed to initialize TTS: $e")),
// //       );
// //     }
// //   }
// //
// //   Future<void> _speak(String text) async {
// //     if (text.isEmpty) return;
// //
// //     if (isSpeaking) {
// //       await _stopSpeaking();
// //       return;
// //     }
// //
// //     try {
// //       await flutterTts.setLanguage(_selectedLanguage);
// //       await flutterTts.speak(text);
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Failed to speak: $e")),
// //       );
// //     }
// //   }
// //
// //   Future<void> _stopSpeaking() async {
// //     try {
// //       await flutterTts.stop();
// //       setState(() {
// //         isSpeaking = false;
// //       });
// //     } catch (e) {
// //       print("Error stopping TTS: $e");
// //     }
// //   }
// //
// //   void deleteMessage(int index) async {
// //     setState(() {
// //       chatHistory.removeAt(index);
// //     });
// //     await _saveChatHistory();
// //   }
// //
// //   void shareMessage(int index) {
// //     final entry = chatHistory[index];
// //     final message = "You: ${entry['question'] ?? 'No Question'}\nLawGPT: ${entry['answer'] ?? 'No Answer'}";
// //     Share.share(message);
// //   }
// //
// //   TextStyle getFontStyleForLanguage(String languageCode) {
// //     switch (languageCode) {
// //       case 'hi-IN':
// //         return GoogleFonts.notoSansDevanagari();
// //       case 'bn-IN':
// //         return GoogleFonts.notoSansBengali();
// //       case 'te-IN':
// //         return GoogleFonts.notoSansTelugu();
// //       case 'mr-IN':
// //         return GoogleFonts.notoSansDevanagari();
// //       case 'ta-IN':
// //         return GoogleFonts.notoSansTamil();
// //       case 'ur-IN':
// //         return GoogleFonts.notoNastaliqUrdu();
// //       case 'gu-IN':
// //         return GoogleFonts.notoSansGujarati();
// //       case 'kn-IN':
// //         return GoogleFonts.notoSansKannada();
// //       case 'ml-IN':
// //         return GoogleFonts.notoSansMalayalam();
// //       case 'pa-IN':
// //         return GoogleFonts.notoSansGurmukhi();
// //       default:
// //         return GoogleFonts.roboto();
// //     }
// //   }
// //
// //   List<Map<String, String>> _getAdvocateSuggestions() {
// //     return [
// //       {
// //         'name': 'Advocate John Doe',
// //         'phone': '+91 1234567890',
// //         'email': 'john.doe@example.com',
// //       },
// //       {
// //         'name': 'Advocate Jane Smith',
// //         'phone': '+91 9876543210',
// //         'email': 'jane.smith@example.com',
// //       },
// //     ];
// //   }
// //
// //   void _showAdvocateSuggestions() {
// //     final advocates = _getAdvocateSuggestions();
// //
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text('Suggested Advocates'),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: advocates.map((advocate) {
// //               return ListTile(
// //                 title: Text(advocate['name'] ?? ''),
// //                 subtitle: Text('Phone: ${advocate['phone']}\nEmail: ${advocate['email']}'),
// //               );
// //             }).toList(),
// //           ),
// //           actions: <Widget>[
// //             TextButton(
// //               child: const Text('Close'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           Container(
// //             decoration: const BoxDecoration(
// //               image: DecorationImage(
// //                 image: AssetImage("assets/ChatBotBackground.jpg"),
// //                 fit: BoxFit.cover,
// //               ),
// //             ),
// //           ),
// //           Column(
// //             children: [
// //               Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: DropdownButton<String>(
// //                   value: _selectedLanguage,
// //                   onChanged: (String? newValue) {
// //                     if (newValue != null) {
// //                       setState(() {
// //                         _selectedLanguage = newValue;
// //                       });
// //                       _initTts();
// //                     }
// //                   },
// //                   items: indianLanguages.entries.map((entry) {
// //                     return DropdownMenuItem<String>(
// //                       value: entry.value,
// //                       child: Text(entry.key),
// //                     );
// //                   }).toList(),
// //                 ),
// //               ),
// //               Expanded(
// //                 child: ListView.builder(
// //                   itemCount: chatHistory.length,
// //                   itemBuilder: (context, index) {
// //                     final entry = chatHistory[index];
// //                     return Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         ListTile(
// //                           title: Text(
// //                             "You: ${entry['question'] ?? 'No Question'}",
// //                             style: getFontStyleForLanguage(_selectedLanguage).copyWith(
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.black,
// //                             ),
// //                           ),
// //                           tileColor: Colors.grey[300]?.withOpacity(0.8),
// //                           trailing: PopupMenuButton<String>(
// //                             onSelected: (value) {
// //                               if (value == 'delete') {
// //                                 deleteMessage(index);
// //                               } else if (value == 'share') {
// //                                 shareMessage(index);
// //                               } else if (value == 'speak') {
// //                                 _speak(entry['answer'] ?? '');
// //                               }
// //                             },
// //                             itemBuilder: (BuildContext context) => [
// //                               const PopupMenuItem<String>(
// //                                 value: 'delete',
// //                                 child: Text('Delete Message'),
// //                               ),
// //                               const PopupMenuItem<String>(
// //                                 value: 'share',
// //                                 child: Text('Share'),
// //                               ),
// //                               const PopupMenuItem<String>(
// //                                 value: 'speak',
// //                                 child: Text('Speak'),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                           ListTile(
// //                             title: Text(
// //                               "LawGPT: ${entry['answer'] ?? 'No Answer'}",
// //                               style: getFontStyleForLanguage(_selectedLanguage).copyWith(
// //                                 color: Colors.black,
// //                               ),
// //                             ),
// //                             tileColor: Colors.white.withOpacity(0.8),
// //                             trailing: Row(
// //                               mainAxisSize: MainAxisSize.min,
// //                               children: [
// //                                 IconButton(
// //                                   icon: Icon(
// //                                     isSpeaking ? Icons.stop_circle : Icons.volume_up,
// //                                     color: isSpeaking ? Colors.red : null,
// //                                   ),
// //                                   onPressed: () {
// //                                     _speak(entry['answer'] ?? '');
// //                                   },
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       );
// //                     },
// //                   ),
// //                 ),
// //                 if (isLoading)
// //                   const Padding(
// //                     padding: EdgeInsets.all(8.0),
// //                     child: CircularProgressIndicator(),
// //                   ),
// //                 Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Row(
// //                     children: [
// //                       Expanded(
// //                         child: TextField(
// //                           controller: controller,
// //                           decoration: InputDecoration(
// //                             hintText: "Ask a question...",
// //                             filled: true,
// //                             fillColor: Colors.white.withOpacity(0.8),
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                           ),
// //                           style: getFontStyleForLanguage(_selectedLanguage),
// //                           onChanged: (text) {
// //                             setState(() {});
// //                           },
// //                         ),
// //                       ),
// //                       IconButton(
// //                         icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
// //                         color: _isListening ? Colors.red : Colors.grey,
// //                         onPressed: _toggleListening,
// //                       ),
// //                       IconButton(
// //                         icon: const Icon(Icons.send),
// //                         color: controller.text.isNotEmpty
// //                             ? Theme.of(context).primaryColor
// //                             : Colors.grey,
// //                         onPressed: controller.text.isNotEmpty ? askQuestion : null,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       );
// //     }
// //   }
//
// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_tts/flutter_tts.dart';
//
// import '../common_pages/lawgpt_service.dart'; // Ensure this path is correct
//
// class ChatScreenUser extends StatefulWidget {
//   const ChatScreenUser({super.key});
//
//   @override
//   _ChatScreenUserState createState() => _ChatScreenUserState();
// }
//
// class _ChatScreenUserState extends State<ChatScreenUser> {
//   // --- Service and Controller ---
//   final LawGPTService service = LawGPTService();
//   final TextEditingController controller = TextEditingController();
//
//   // --- State Variables ---
//   bool isLoading = false;
//   List<Map<String, String>> chatHistory = [];
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;
//   bool isSpeaking = false;
//   String _text = "Tap the microphone to start"; // Used for internal state/debug, not directly in the final UI
//   String _selectedLanguage = 'en-IN';
//   final FlutterTts flutterTts = FlutterTts();
//
//   // --- Language Map ---
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
//   // ------------------------------------
//   // --- Lifecycle and Initialization ---
//   // ------------------------------------
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
//   // ------------------------------------
//   // --- Data and Persistence Logic ---
//   // ------------------------------------
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
//       // Get history questions for context
//       final historyQuestions = chatHistory.map((entry) => entry["question"] ?? '').toList();
//
//       // Clear the text field immediately for better UX
//       controller.clear();
//
//       final answer = await service.askQuestion(
//         question,
//         historyQuestions,
//       );
//
//       setState(() {
//         chatHistory.add({"question": question, "answer": answer});
//       });
//
//       await _saveChatHistory();
//     } catch (e) {
//       // Use the root context to ensure SnackBar shows correctly
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Error: Failed to get answer - $e")));
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
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
//     Share.share(message, subject: "LawGPT Chat History");
//   }
//
//   // ------------------------------------
//   // --- Speech-to-Text (STT) Logic ---
//   // ------------------------------------
//
//   void _initSpeech() async {
//     try {
//       bool available = await _speech.initialize();
//       if (!available) {
//         setState(() {
//           _text = "Speech recognition is not available.";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _text = "Failed to initialize speech recognition: $e";
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
//           _text = "Listening...";
//         });
//       } else {
//         setState(() {
//           _text = "Speech recognition not available";
//         });
//       }
//     } else {
//       await _speech.stop();
//       setState(() {
//         _isListening = false;
//         _text = "Tap the microphone to start";
//       });
//     }
//   }
//
//   // ------------------------------------
//   // --- Text-to-Speech (TTS) Logic ---
//   // ------------------------------------
//
//   void _initTts() async {
//     try {
//       await flutterTts.setLanguage(_selectedLanguage);
//       await flutterTts.setSpeechRate(0.5);
//       await flutterTts.setVolume(1.0);
//       await flutterTts.setPitch(1.0);
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Failed to initialize TTS: $e")));
//       }
//     }
//   }
//
//   Future<void> _speak(String text) async {
//     if (text.isEmpty) return;
//
//     // Stop speaking if currently speaking
//     await _stopSpeaking();
//
//     try {
//       await flutterTts.setLanguage(_selectedLanguage);
//       await flutterTts.speak(text);
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Failed to speak: $e")));
//       }
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
//   // ------------------------------------
//   // --- Styling and Font Logic ---
//   // ------------------------------------
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
//         return GoogleFonts.roboto(); // Default for English and others
//     }
//   }
//
//   // ------------------------------------
//   // --- UI Build Methods (Enhanced) ---
//   // ------------------------------------
//
//   @override
//   Widget build(BuildContext context) {
//     // Get the dynamic font style based on the selected language
//     final TextStyle currentFontStyle = getFontStyleForLanguage(_selectedLanguage);
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image (Ensure you have this asset)
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/ChatBotBackground.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // A semi-transparent overlay for better text readability
//           Container(
//             color: Colors.white.withOpacity(0.4),
//           ),
//           Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   itemCount: chatHistory.length,
//                   // Reverse the list to show the latest messages at the bottom
//                   reverse: true,
//                   itemBuilder: (context, index) {
//                     final reversedIndex = chatHistory.length - 1 - index;
//                     final entry = chatHistory[reversedIndex];
//                     return _buildMessageBubble(entry, currentFontStyle, reversedIndex);
//                   },
//                 ),
//               ),
//               if (isLoading)
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: LinearProgressIndicator(color: Colors.lightGreen), // Less intrusive loading
//                 ),
//               // Input area at the bottom
//               _buildInputArea(currentFontStyle),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLanguageDropdown() {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8.0),
//       child: DropdownButton<String>(
//         value: _selectedLanguage,
//         icon: const Icon(Icons.language, color: Colors.white),
//         underline: const SizedBox(), // Remove the default underline
//         dropdownColor: Theme.of(context).primaryColor.withOpacity(0.9),
//         onChanged: (String? newValue) {
//           if (newValue != null) {
//             setState(() {
//               _selectedLanguage = newValue;
//             });
//             _initTts();
//           }
//         },
//         items: indianLanguages.entries.map((entry) {
//           return DropdownMenuItem<String>(
//             value: entry.value,
//             child: Text(
//               entry.key.split('(').first.trim(), // Display only language name
//               style: GoogleFonts.roboto(color: Colors.white, fontSize: 14),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   Widget _buildMessageBubble(Map<String, String> entry, TextStyle fontStyle, int index) {
//     final String question = entry['question'] ?? 'No Question';
//     final String answer = entry['answer'] ?? 'No Answer';
//
//     // Message bubble for the User (Right-aligned)
//     Widget userBubble = Align(
//       alignment: Alignment.centerRight,
//       child: Container(
//         margin: const EdgeInsets.only(top: 8, bottom: 2, left: 60),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Theme.of(context).primaryColor, // User's message color
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(16),
//             topRight: Radius.circular(16),
//             bottomLeft: Radius.circular(16),
//             bottomRight: Radius.circular(4), // Tail effect
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.15),
//               blurRadius: 3,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Text(
//           question,
//           style: fontStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//
//     // Message bubble for LawGPT (Left-aligned)
//     Widget lawGPTBubble = Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(top: 2, bottom: 8, right: 60),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(16),
//             topRight: Radius.circular(16),
//             bottomRight: Radius.circular(16),
//             bottomLeft: Radius.circular(4), // Tail effect
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 3,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               answer,
//               style: fontStyle.copyWith(color: Colors.black87),
//             ),
//             const SizedBox(height: 8),
//             _buildMessageActions(entry, index),
//           ],
//         ),
//       ),
//     );
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         userBubble,
//         lawGPTBubble,
//       ],
//     );
//   }
//
//   Widget _buildMessageActions(Map<String, String> entry, int index) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Speak/Stop Button
//         IconButton(
//           icon: Icon(
//             // Check if this specific message is currently being spoken
//             (isSpeaking && chatHistory.length - 1 - index == 0) ? Icons.stop : Icons.volume_up,
//             color: (isSpeaking && chatHistory.length - 1 - index == 0) ? Colors.redAccent : Colors.grey.shade600,
//             size: 18,
//           ),
//           onPressed: () => _speak(entry['answer'] ?? ''),
//           tooltip: (isSpeaking && chatHistory.length - 1 - index == 0) ? 'Stop Reading' : 'Read Aloud',
//         ),
//         // Share Button
//         IconButton(
//           icon: Icon(Icons.share, color: Colors.grey.shade600, size: 18),
//           onPressed: () => shareMessage(index),
//           tooltip: 'Share',
//         ),
//         // Delete Button
//         IconButton(
//           icon: Icon(Icons.delete_outline, color: Colors.grey.shade600, size: 18),
//           onPressed: () => deleteMessage(index),
//           tooltip: 'Delete',
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInputArea(TextStyle fontStyle) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Material(
//         elevation: 8,
//         borderRadius: BorderRadius.circular(30),
//         shadowColor: Colors.black45,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: Row(
//             children: [
//               // Speech-to-Text Button
//               IconButton(
//                 icon: Icon(
//                   _isListening ? Icons.mic : Icons.mic_none,
//                   color: _isListening ? Colors.redAccent : Theme.of(context).primaryColor,
//                 ),
//                 onPressed: _toggleListening,
//                 tooltip: _isListening ? 'Stop Listening' : 'Start Voice Input',
//               ),
//               Expanded(
//                 child: TextField(
//                   controller: controller,
//                   decoration: InputDecoration(
//                     hintText: "Ask a legal question...",
//                     hintStyle: GoogleFonts.roboto(color: Colors.grey),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   ),
//                   style: fontStyle.copyWith(color: Colors.black87),
//                   onChanged: (text) {
//                     setState(() {});
//                   },
//                 ),
//               ),
//               // Send Button
//               Padding(
//                 padding: const EdgeInsets.only(right: 4.0),
//                 child: CircleAvatar(
//                   backgroundColor: controller.text.isNotEmpty
//                       ? Theme.of(context).primaryColor
//                       : Colors.grey.shade400,
//                   child: IconButton(
//                     icon: const Icon(Icons.send, color: Colors.white, size: 20),
//                     onPressed: controller.text.isNotEmpty ? askQuestion : null,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../common_pages/lawgpt_service.dart';

class ChatScreenUser extends StatefulWidget {
  final VoidCallback? onNavigateToChat; // Callback to switch to Chat tab

  const ChatScreenUser({super.key, this.onNavigateToChat});

  @override
  _ChatScreenUserState createState() => _ChatScreenUserState();
}

class _ChatScreenUserState extends State<ChatScreenUser> {
  // --- Service and Controller ---
  final LawGPTService service = LawGPTService();
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // --- State Variables ---
  bool isLoading = false;
  List<Map<String, String>> chatHistory = [];
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool isSpeaking = false;
  String _selectedLanguage = 'en-IN';
  final FlutterTts flutterTts = FlutterTts();

  // --- Language Map ---
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

  // ------------------------------------
  // --- Lifecycle and Initialization ---
  // ------------------------------------

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
    super.dispose();
  }

  // ------------------------------------
  // --- Auto Scroll Logic ---
  // ------------------------------------

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

  // ------------------------------------
  // --- Data and Persistence Logic ---
  // ------------------------------------

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

    setState(() {
      isLoading = true;
    });

    try {
      final question = controller.text;
      final historyQuestions = chatHistory.map((entry) => entry["question"] ?? '').toList();

      controller.clear();

      final answer = await service.askQuestion(
        question,
        historyQuestions,
      );

      setState(() {
        chatHistory.add({"question": question, "answer": answer});
      });

      await _saveChatHistory();
      _scrollToBottom();

      // Show advocate contact dialog after response
      _showAdvocateContactDialog();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: Failed to get answer - $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
    Share.share(message, subject: "LawGPT Chat History");
  }

  // ------------------------------------
  // --- Advocate Contact Dialog ---
  // ------------------------------------

  void _showAdvocateContactDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.gavel, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              const Text('Need Legal Help?'),
            ],
          ),
          content: const Text(
            'Would you like to contact an advocate for personalized legal assistance?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Not Now',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToAdvocateChat();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.chat, size: 18),
              label: const Text('Contact Advocate',style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAdvocateChat() {
    // Use the callback if provided
    if (widget.onNavigateToChat != null) {
      widget.onNavigateToChat!();
    // } else {
    //   // Fallback: Show a message
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Please go to the Chat tab to contact an advocate'),
    //       duration: Duration(seconds: 3),
    //       backgroundColor: Colors.orange,
    //     ),
    //   );
    }
  }

  // ------------------------------------
  // --- Speech-to-Text (STT) Logic ---
  // ------------------------------------

  void _initSpeech() async {
    try {
      bool available = await _speech.initialize();
      if (!available) {
        setState(() {
        });
      }
    } catch (e) {
      setState(() {
      });
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
      } else {
        setState(() {
        });
      }
    } else {
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  // ------------------------------------
  // --- Text-to-Speech (TTS) Logic ---
  // ------------------------------------

  void _initTts() async {
    try {
      await flutterTts.setLanguage(_selectedLanguage);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to initialize TTS: $e")));
      }
    }
  }

  Future<void> _speak(String text) async {
    if (text.isEmpty) return;

    await _stopSpeaking();

    try {
      await flutterTts.setLanguage(_selectedLanguage);
      await flutterTts.speak(text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to speak: $e")));
      }
    }
  }

  Future<void> _stopSpeaking() async {
    await flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  // ------------------------------------
  // --- Styling and Font Logic ---
  // ------------------------------------

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

  // ------------------------------------
  // --- UI Build Methods ---
  // ------------------------------------

  @override
  Widget build(BuildContext context) {
    final TextStyle currentFontStyle = getFontStyleForLanguage(_selectedLanguage);

    return Scaffold(
      backgroundColor: Colors.transparent,
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
          Container(
            color: Colors.white.withOpacity(0.4),
          ),
          Column(
            children: [
              Expanded(
                child: chatHistory.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  itemCount: chatHistory.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final reversedIndex = chatHistory.length - 1 - index;
                    final entry = chatHistory[reversedIndex];
                    return _buildMessageBubble(entry, currentFontStyle, reversedIndex);
                  },
                ),
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(color: Colors.lightGreen),
                ),
              _buildInputArea(currentFontStyle),
            ],
          ),
          // Floating language selector button
          Positioned(
            top: 16,
            right: 16,
            child: _buildLanguageDropdown(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Ask your legal questions',
            style: GoogleFonts.roboto(
              fontSize: 20,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with LawGPT',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return DropdownButton<String>(
      value: _selectedLanguage,
      icon: const Icon(Icons.language, color: Colors.white),
      underline: const SizedBox(),
      dropdownColor: Theme.of(context).primaryColor.withOpacity(0.9),
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
          child: Text(
            entry.key.split('(').first.trim(),
            style: GoogleFonts.roboto(color: Colors.white, fontSize: 14),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMessageBubble(Map<String, String> entry, TextStyle fontStyle, int index) {
    final String question = entry['question'] ?? 'No Question';
    final String answer = entry['answer'] ?? 'No Answer';

    Widget userBubble = Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 2, left: 60),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          question,
          style: fontStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );

    Widget lawGPTBubble = Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 2, bottom: 8, right: 60),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              answer,
              style: fontStyle.copyWith(color: Colors.black87),
            ),
            const SizedBox(height: 8),
            _buildMessageActions(entry, index),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        userBubble,
        lawGPTBubble,
      ],
    );
  }

  Widget _buildMessageActions(Map<String, String> entry, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            isSpeaking ? Icons.stop : Icons.volume_up,
            color: isSpeaking ? Colors.redAccent : Colors.grey.shade600,
            size: 18,
          ),
          onPressed: () => _speak(entry['answer'] ?? ''),
          tooltip: isSpeaking ? 'Stop Reading' : 'Read Aloud',
        ),
        IconButton(
          icon: Icon(Icons.share, color: Colors.grey.shade600, size: 18),
          onPressed: () => shareMessage(index),
          tooltip: 'Share',
        ),
        IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.grey.shade600, size: 18),
          onPressed: () => deleteMessage(index),
          tooltip: 'Delete',
        ),
      ],
    );
  }

  Widget _buildInputArea(TextStyle fontStyle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(30),
        shadowColor: Colors.black45,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.redAccent : Theme.of(context).primaryColor,
                ),
                onPressed: _toggleListening,
                tooltip: _isListening ? 'Stop Listening' : 'Start Voice Input',
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Ask a legal question...",
                    hintStyle: GoogleFonts.roboto(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  ),
                  style: fontStyle.copyWith(color: Colors.black87),
                  onChanged: (text) {
                    setState(() {});
                  },
                  onSubmitted: (text) {
                    if (text.isNotEmpty) askQuestion();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: CircleAvatar(
                  backgroundColor: controller.text.isNotEmpty
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade400,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: controller.text.isNotEmpty ? askQuestion : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}