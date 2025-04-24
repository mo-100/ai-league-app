import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import '../models/chat_message.dart';

class ChatService {
  final String baseUrl;
  final Duration timeout = const Duration(seconds: 10);

  ChatService({required this.baseUrl});

  /// Sends a message to the preorder chatbot
  Future<ChatMessage> sendPreorderMessage(String message, {File? image}) async {
    try {
      final Map<String, dynamic> requestBody = {'query': message};

      // Add image if provided
      if (image != null) {
        final bytes = await image.readAsBytes();
        requestBody['image_data'] = base64Encode(bytes);
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/pchat'),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Accept': 'application/json; charset=utf-8',
            },
            body: jsonEncode(requestBody),
            encoding: utf8,
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);
        return ChatMessage(
          text: data['response'],
          isUser: false,
          timestamp: DateTime.now(),
        );
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      return ChatMessage(
        text: 'Error: $e',
        isUser: false,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Sends a message to the emergency reporting chatbot
  Future<ChatMessage> sendEmergencyReportMessage(
    String message, {
    File? image,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {'query': message};

      // Add image if provided
      if (image != null) {
        final bytes = await image.readAsBytes();
        requestBody['image_data'] = base64Encode(bytes);
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/rchat'),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Accept': 'application/json; charset=utf-8',
            },
            body: jsonEncode(requestBody),
            encoding: utf8,
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);
        return ChatMessage(
          text: data['response'],
          isUser: false,
          timestamp: DateTime.now(),
        );
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      return ChatMessage(
        text: 'Error: $e',
        isUser: false,
        timestamp: DateTime.now(),
      );
    }
  }

  Future<ChatMessage> sendAudioMessage(File audioFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/audio-chat'),
      );

      // Add audio file to the request
      final audioStream = http.ByteStream(audioFile.openRead());
      final audioLength = await audioFile.length();

      // Determine mime type based on file extension
      final String extensionName = extension(audioFile.path).toLowerCase();
      String mimeType = 'audio/wav'; // default

      if (extensionName == '.mp3') {
        mimeType = 'audio/mpeg';
      } else if (extensionName == '.m4a') {
        mimeType = 'audio/m4a';
      } else if (extensionName == '.ogg') {
        mimeType = 'audio/ogg';
      } else if (extensionName == '.flac') {
        mimeType = 'audio/flac';
      }

      // This is the key fix - use 'file' as the field name instead of 'audio'
      // to match what your FastAPI endpoint expects
      final audioUpload = http.MultipartFile(
        'file', // Changed from 'audio' to 'file' to match the FastAPI parameter name
        audioStream,
        audioLength,
        filename: basename(audioFile.path),
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(audioUpload);

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatMessage(
          text: data['response'],
          isUser: false,
          timestamp: DateTime.now(),
        );
      } else {
        throw Exception('Failed to process audio: ${response.statusCode}');
      }
    } catch (e) {
      return ChatMessage(
        text: 'Error processing audio: $e',
        isUser: false,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Clears conversation history on the server
  Future<bool> clearChatHistory() async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/clear'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(timeout);

      return response.statusCode == 200;
    } catch (e) {
      print('Error clearing chat history: $e');
      return false;
    }
  }
}
