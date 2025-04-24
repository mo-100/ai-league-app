import 'dart:io'; // Import File
import 'package:ai_league_app/constants/app_constants.dart';
import 'package:ai_league_app/widgets/message_text_field.dart';
import 'package:ai_league_app/widgets/send_button.dart';
import 'package:flutter/material.dart';

class MessageInputArea extends StatelessWidget {
  final TextEditingController messageController;
  final bool isProcessing;
  final VoidCallback? onSendMessage;
  final Widget? icon;
  final File? selectedImage; // Added: To receive the selected image file
  final VoidCallback?
  onClearImage; // Added: Callback to clear the selected image

  const MessageInputArea({
    super.key,
    required this.messageController,
    required this.isProcessing,
    required this.onSendMessage,
    this.icon,
    this.selectedImage, // Added to constructor
    this.onClearImage, // Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstants.mainColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: AppConstants.matchColor),
          color: AppConstants.secondaryColor.withOpacity(.5),
        ),
        // Use Column to stack image preview (if any) and the input row
        child: Column(
          mainAxisSize: MainAxisSize.min, // Take minimum vertical space
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Conditionally display the image preview
            if (selectedImage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        selectedImage!,
                        height: 150, // Adjust preview height as needed
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    // Small button to clear the selected image
                    Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(), // Remove default padding
                        tooltip: 'Remove image',
                        onPressed: onClearImage, // Use the callback
                      ),
                    ),
                  ],
                ),
              ),
            // Original input row
            Row(
              children: [
                Expanded(
                  child: MessageTextField(
                    controller: messageController,
                    onSubmitted: (_) {
                      if (onSendMessage != null) {
                        return onSendMessage!();
                      }
                    },
                    icon: icon,
                  ),
                ),
                const SizedBox(width: 10),
                SendButton(
                  isProcessing: isProcessing,
                  onPressed: onSendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
