import 'package:ai_league_app/constants/app_constants.dart';
import 'package:ai_league_app/models/chat_message.dart';
import 'package:ai_league_app/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;

  const ChatMessages({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: AppConstants.mainColor,
        child: ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return MessageBubble(
              message: messages[index],
            );
          },
        ),
      ),
    );
  }
}
