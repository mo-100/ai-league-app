import 'package:ai_league_app/constants/app_constants.dart';
import 'package:flutter/material.dart';

class MessageTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final Widget? icon;

  const MessageTextField({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppConstants.chatColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppConstants.chatBorderColor
        )
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Ask me anything...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                ),
              ),
              onSubmitted: onSubmitted,
            ),
          ),
          if (icon != null)
            icon!,
        ],
      ),
    );
  }
}
