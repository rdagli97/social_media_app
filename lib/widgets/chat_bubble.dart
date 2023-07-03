import 'package:event_app/utils/add_space.dart';
import 'package:event_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String emailText;
  final String message;
  const ChatBubble({
    super.key,
    required this.emailText,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade700,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // email text
          CustomText(
            text: emailText,
            fontWeight: FontWeight.w300,
          ),
          addVerticalSpace(5),
          // message text
          CustomText(
            text: message,
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}
