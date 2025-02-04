import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LawGPTService {
  final String baseUrl = "https://aniudupa-fir-gen.hf.space/lawgpt/";

  Future<String> askQuestion(String question, List<String> chatHistory) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}chat/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "question": question,
          "chat_history": "what",
        }),
      );

      if (kDebugMode) {
        print("Response Status Code: ${response.statusCode}");
      } // Debugging
      if (kDebugMode) {
        print("Raw Response Body: ${response.body}");
      } // Debugging

      if (response.statusCode == 200) {
        String rawBody = utf8.decode(response.bodyBytes).trim();

        if (rawBody.isEmpty) {
          throw Exception("Received empty response from the API.");
        }

        final responseData = jsonDecode(rawBody);
        return responseData["answer"];
      } else {
        if (kDebugMode) {
          print("Server Error: ${response.statusCode}, Response: ${response.body}");
        }
        throw Exception("Server error: ${response.statusCode}, Response: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error occurred while connecting to LawGPT API: $e");
      }
      throw Exception("An error occurred while connecting to LawGPT API: $e");
    }
  }
}

void main() async {
  final service = LawGPTService();

  try {
    final question = "What is Section 302 of IPC?";
    final chatHistory = [
      "What is Section 300 of IPC?",
      "What are the provisions under it?"
    ];

    if (kDebugMode) {
      print("Sending question to LawGPT...");
    }
    final answer = await service.askQuestion(question, chatHistory);
    if (kDebugMode) {
      print("LawGPT Answer: $answer");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
  }
}
