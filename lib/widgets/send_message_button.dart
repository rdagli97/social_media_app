import 'package:flutter/material.dart';

class SendMessageButton extends StatelessWidget {
  final Function()? onTap;
  final Color? color;
  final Widget widget;
  const SendMessageButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: widget,
        ),
      ),
    );
  }
}
