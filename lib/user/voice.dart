import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechDemo extends StatefulWidget {
  const SpeechDemo({Key? key}) : super(key: key);

  @override
  State<SpeechDemo> createState() => _SpeechDemoState();
}

class _SpeechDemoState extends State<SpeechDemo> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = "Tap the microphone to start";

  @override
  void initState() {
    super.initState();
    _initSpeech();
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
            _text = result.recognizedWords;
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
      appBar: AppBar(
        title: const Text('Speech Demo'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _isListening ? "Listening..." : _text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        child: Icon(_isListening ? Icons.mic : Icons.mic_off),
      ),
    );
  }
}
