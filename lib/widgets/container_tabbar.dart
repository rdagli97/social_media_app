import 'package:flutter/material.dart';

class ContainerTabbar extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool topLeftPadding;
  final Color? color;
  const ContainerTabbar({
    super.key,
    required this.onTap,
    required this.text,
    required this.topLeftPadding,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: topLeftPadding
                ? const Radius.circular(40)
                : const Radius.circular(0),
            topRight: topLeftPadding
                ? const Radius.circular(0)
                : const Radius.circular(40),
          ),
        ),
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
