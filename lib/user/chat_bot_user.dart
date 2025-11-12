import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../common_pages/lawgpt_service.dart';

class ChatScreenUser extends StatefulWidget {
  final VoidCallback? onNavigateToChat;

  const ChatScreenUser({super.key, this.onNavigateToChat});

  @override
  _ChatScreenUserState createState() => _ChatScreenUserState();
}

class _ChatScreenUserState extends State<ChatScreenUser> with TickerProviderStateMixin {
  final LawGPTService service = LawGPTService();
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool isLoading = false;
  List<Map<String, String>> chatHistory = [];
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool isSpeaking = false;
  int? currentSpeakingIndex;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A5FE8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.gavel,
                  color: const Color(0xFF4A5FE8),
                  size: isSmallScreen ? 20 : 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Need Legal Help?',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Would you like to contact an advocate for personalized legal assistance?',
            style: TextStyle(fontSize: isSmallScreen ? 14 : 16, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Not Now',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToAdvocateChat();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A5FE8),
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 20,
                  vertical: isSmallScreen ? 10 : 12,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              icon: Icon(Icons.chat, size: isSmallScreen ? 16 : 18, color: Colors.white),
              label: Text(
                'Contact Advocate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
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

    if (isSpeaking && currentSpeakingIndex == messageIndex) {
      await _stopSpeaking();
      return;
    }

    if (isSpeaking) {
      await _stopSpeaking();
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

  String _getLanguageDisplayName() {
    final entry = indianLanguages.entries.firstWhere(
          (e) => e.value == _selectedLanguage,
      orElse: () => const MapEntry('English (India)', 'en-IN'),
    );
    return entry.key.split('(').first.trim();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle currentFontStyle = getFontStyleForLanguage(_selectedLanguage);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(screenWidth),
      body: Column(
        children: [
          Expanded(
            child: chatHistory.isEmpty
                ? _buildEmptyState(screenWidth)
                : _buildChatList(currentFontStyle, screenWidth),
          ),
          _buildInputArea(currentFontStyle, screenWidth),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(double screenWidth) {
    final isSmallScreen = screenWidth < 600;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.05),
      surfaceTintColor: Colors.transparent,
      actions: [
        // Language Selector
        GestureDetector(
          onTap: _showLanguageBottomSheet,
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 10 : 12,
              vertical: isSmallScreen ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF4A5FE8).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language,
                  color: const Color(0xFF4A5FE8),
                  size: isSmallScreen ? 18 : 20,
                ),
                if (!isSmallScreen) ...[
                  const SizedBox(width: 6),
                  Text(
                    _getLanguageDisplayName(),
                    style: const TextStyle(
                      color: Color(0xFF4A5FE8),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildChatList(TextStyle fontStyle, double screenWidth) {
    final horizontalPadding = screenWidth < 600 ? 12.0 : (screenWidth < 1024 ? 24.0 : 32.0);

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16.0),
      itemCount: chatHistory.length,
      reverse: true,
      itemBuilder: (context, index) {
        final reversedIndex = chatHistory.length - 1 - index;
        final entry = chatHistory[reversedIndex];
        return _buildMessageBubble(entry, fontStyle, reversedIndex, screenWidth);
      },
    );
  }

  void _showLanguageBottomSheet() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
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
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A5FE8).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.language,
                        color: const Color(0xFF4A5FE8),
                        size: isSmallScreen ? 20 : 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Select Language',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
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
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16 : 20,
                        vertical: isSmallScreen ? 4 : 8,
                      ),
                      leading: Container(
                        padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF4A5FE8).withOpacity(0.1)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          color: isSelected ? const Color(0xFF4A5FE8) : Colors.grey,
                          size: isSmallScreen ? 18 : 20,
                        ),
                      ),
                      title: Text(
                        entry.key.split('(').first.trim(),
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? const Color(0xFF4A5FE8) : Colors.black87,
                          fontSize: isSmallScreen ? 14 : 16,
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
              SizedBox(height: isSmallScreen ? 16 : 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(double screenWidth) {
    final isSmallScreen = screenWidth < 600;
    final iconSize = isSmallScreen ? 48.0 : 64.0;
    final titleSize = isSmallScreen ? 20.0 : 24.0;
    final subtitleSize = isSmallScreen ? 14.0 : 16.0;
    final horizontalPadding = isSmallScreen ? 24.0 : 40.0;

    return Center(
      child: SingleChildScrollView(
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
                    padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4A5FE8).withOpacity(0.1),
                          const Color(0xFF6B7FFF).withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.gavel,
                      size: iconSize,
                      color: const Color(0xFF4A5FE8),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: isSmallScreen ? 20 : 24),
            Text(
              'Welcome to LawGPT',
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                'Ask any legal question and get instant AI-powered answers',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
            _buildSuggestionChips(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChips(double screenWidth) {
    final suggestions = [
      'Property Rights',
      'Employment Law',
      'Contract Disputes',
    ];
    final isSmallScreen = screenWidth < 600;
    final horizontalPadding = isSmallScreen ? 16.0 : 0.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Wrap(
        spacing: isSmallScreen ? 8 : 12,
        runSpacing: isSmallScreen ? 8 : 12,
        alignment: WrapAlignment.center,
        children: suggestions.map((suggestion) {
          return GestureDetector(
            onTap: () {
              controller.text = "Tell me about $suggestion";
              askQuestion();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 20,
                vertical: isSmallScreen ? 10 : 12,
              ),
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
                style: TextStyle(
                  color: const Color(0xFF4A5FE8),
                  fontWeight: FontWeight.w500,
                  fontSize: isSmallScreen ? 13 : 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMessageBubble(
      Map<String, String> entry,
      TextStyle fontStyle,
      int index,
      double screenWidth,
      ) {
    final String question = entry['question'] ?? 'No Question';
    final String answer = entry['answer'] ?? 'No Answer';
    final bool isTyping = answer == "typing";
    final bool isThisMessageSpeaking = currentSpeakingIndex == index && isSpeaking;
    final isSmallScreen = screenWidth < 600;
    final messagePadding = isSmallScreen ? 12.0 : 16.0;
    final fontSize = isSmallScreen ? 14.0 : 15.0;
    final messageMargin = isSmallScreen ? 40.0 : 60.0;

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
              margin: EdgeInsets.only(top: 8, bottom: 8, left: messageMargin),
              padding: EdgeInsets.all(messagePadding),
              constraints: BoxConstraints(
                maxWidth: screenWidth * (isSmallScreen ? 0.8 : 0.7),
              ),
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
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
          // AI Response
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(top: 0, bottom: 8, right: messageMargin),
              padding: EdgeInsets.all(messagePadding),
              constraints: BoxConstraints(
                maxWidth: screenWidth * (isSmallScreen ? 0.8 : 0.7),
              ),
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
                        fontSize: fontSize,
                        height: 1.5,
                      ),
                    ),
                  if (!isTyping) ...[
                    SizedBox(height: isSmallScreen ? 8 : 12),
                    _buildMessageActions(entry, index, isThisMessageSpeaking, isSmallScreen),
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

  Widget _buildMessageActions(
      Map<String, String> entry,
      int index,
      bool isThisMessageSpeaking,
      bool isSmallScreen,
      ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: isThisMessageSpeaking ? Icons.stop_circle : Icons.volume_up,
          onPressed: () => _speak(entry['answer'] ?? '', index),
          tooltip: isThisMessageSpeaking ? 'Stop' : 'Listen',
          isActive: isThisMessageSpeaking,
          isSmallScreen: isSmallScreen,
        ),
        SizedBox(width: isSmallScreen ? 6 : 8),
        _buildActionButton(
          icon: Icons.share_outlined,
          onPressed: () => shareMessage(index),
          tooltip: 'Share',
          isSmallScreen: isSmallScreen,
        ),
        SizedBox(width: isSmallScreen ? 6 : 8),
        _buildActionButton(
          icon: Icons.delete_outline,
          onPressed: () => deleteMessage(index),
          tooltip: 'Delete',
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    bool isActive = false,
    required bool isSmallScreen,
  }) {
    final iconSize = isSmallScreen ? 16.0 : 18.0;
    final padding = isSmallScreen ? 6.0 : 8.0;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: isActive
              ? BoxDecoration(
            color: const Color(0xFF4A5FE8).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          )
              : null,
          child: Icon(
            icon,
            size: iconSize,
            color: isActive ? const Color(0xFF4A5FE8) : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(TextStyle fontStyle, double screenWidth) {
    final isSmallScreen = screenWidth < 600;
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;
    final verticalPadding = isSmallScreen ? 12.0 : 16.0;
    final fontSize = isSmallScreen ? 14.0 : 15.0;
    final iconSize = isSmallScreen ? 22.0 : 24.0;
    final sendButtonSize = isSmallScreen ? 10.0 : 12.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
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
      child: SafeArea(
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
                        size: iconSize,
                      ),
                      onPressed: _toggleListening,
                      tooltip: _isListening ? 'Stop Listening' : 'Voice Input',
                      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: "Ask your legal question...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: fontSize,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 10 : 12,
                          ),
                        ),
                        style: fontStyle.copyWith(
                          color: Colors.black87,
                          fontSize: fontSize,
                        ),
                        onChanged: (text) {
                          setState(() {});
                        },
                        onSubmitted: (text) {
                          if (text.isNotEmpty) askQuestion();
                        },
                        maxLines: null,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 4 : 8),
                  ],
                ),
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
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
                    padding: EdgeInsets.all(sendButtonSize),
                    child: Icon(
                      isLoading ? Icons.stop : Icons.send,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}