import 'package:event_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? onTap;
  final Color? color;
  final String text;
  final Color? textColor;
  const FollowButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: CustomText(
            text: text,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
