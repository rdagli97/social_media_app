import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final bool isPass;
  final TextInputType? keyboardType;
  final String hintText;
  final Widget? prefixIcon;
  final double? height;
  final double? width;
  const CustomTextfield({
    super.key,
    required this.controller,
    this.isPass = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    required this.hintText,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        controller: controller,
        obscureText: isPass,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black.withOpacity(0),
          hintText: hintText,
          hintStyle: const TextStyle(fontStyle: FontStyle.italic),
          prefixIcon: prefixIcon,
          prefixIconColor: Colors.grey.shade400,
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}
