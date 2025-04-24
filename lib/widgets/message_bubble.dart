import 'package:ai_league_app/constants/app_constants.dart';
import 'package:ai_league_app/models/chat_message.dart';
import 'package:ai_league_app/utils.dart';
import 'package:ai_league_app/widgets/audio_player.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  Widget _getBotAvatar(BuildContext context) {
    // ... existing code ...
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/bot_avatar.png',
          width: 37,
          height: 37,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.smart_toy,
              color: Color(0xFF2ABDA0),
              size: 24,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the bubble contains only audio
    final bool hasText = message.text.trim().isNotEmpty;
    final bool hasImage = message.image != null;
    final bool hasAudio = message.audio != null; // Check for audio
    final bool isOnlyAudio = hasAudio && !hasText && !hasImage;

    return Padding(
      padding: message.isUser
          ? const EdgeInsets.only(top: 5, bottom: 5, left: 90)
          : const EdgeInsets.only(top: 5, bottom: 5, right: 70),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) _getBotAvatar(context),
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Use _makeBubble only if there's text or image
                if (hasText || hasImage)
                  _makeBubble(message, hasText, hasImage),
                // Conditionally display the audio player *outside* the main bubble
                // if it's the only content, or *inside* if combined with text/image.
                // This example places it inside the bubble structure.
                if (hasAudio)
                   _buildAudioPlayerContainer(message), // Add audio player

                // Display timestamp only if there's *any* content
                if (hasText || hasImage || hasAudio)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      getTimeStr(message.timestamp, context),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Updated _makeBubble to handle text and image separately within the bubble
  Widget _makeBubble(ChatMessage message, bool hasText, bool hasImage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: _getBubbleDecoration(message.isUser),
      child: Column( // Use Column to stack image and text if both exist
        crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (hasImage)
            Padding(
              padding: EdgeInsets.only(bottom: hasText ? 8.0 : 0.0), // Add spacing if text follows
              child: ClipRRect( // Clip image corners
                 borderRadius: BorderRadius.circular(15), // Match bubble radius
                 child: Image.file(message.image!, width: 200, height: 200, fit: BoxFit.cover),
              ),
            ),
          if (hasText)
            Text(
              message.text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          // Audio player is handled separately now
        ],
      ),
    );
  }

   // Helper function to build the container for the audio player
   Widget _buildAudioPlayerContainer(ChatMessage message) {
     // Reuse the bubble decoration but adjust padding for the player
     return Container(
       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Less padding for player
       constraints: BoxConstraints(maxWidth: 250), // Constrain player width
       decoration: _getBubbleDecoration(message.isUser),
       child: AudioPlayerWidget(
         audioFile: message.audio!,
       ),
     );
   }


  // Helper for bubble decoration to avoid repetition
  BoxDecoration _getBubbleDecoration(bool isUser) {
    return isUser
        ? const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2ABDA0), Color(0xFF2A77BD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            ),
          )
        : BoxDecoration(
            color: AppConstants.chatColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            border: Border.all(color: AppConstants.chatBorderColor));
  }
}