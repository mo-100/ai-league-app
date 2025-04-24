import 'dart:io';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final File? image;
  final File? audio;

  ChatMessage({
    required this.text, 
    required this.isUser, 
    required this.timestamp,
    this.image,
    this.audio, 
  });
}