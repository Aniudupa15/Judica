import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../common_pages/lawgpt_service.dart';

class ChatScreenJudge extends StatefulWidget {
  const ChatScreenJudge({super.key});

  @override
  _ChatScreenJudgeState createState() => _ChatScreenJudgeState();
}

class _ChatScreenJudgeState extends State<ChatScreenJudge> {
  final LawGPTService service = LawGPTService();
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;
  List<Map<String, String>> chatHistory = [];
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = "Tap the microphone to start";

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
    _initSpeech();
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
      bool available = await _speech.listen(
        onResult: (result) {
          setState(() {
            controller.text = result.recognizedWords;
          });
        },
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
      }
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
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
                            style: TextStyle(
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
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "LawGPT: ${entry['answer']}",
                            style: const TextStyle(color: Colors.black),
                          ),
                          tileColor: Colors.white.withOpacity(0.8),
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
                        onSubmitted: (value) {
                          askQuestion();
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(_isListening ? Icons.mic : Icons.mic_off),
                      color: Colors.red,
                      onPressed: _isListening ? _stopListening : _startListening,
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Theme.of(context).primaryColor,
                      onPressed: askQuestion,
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
