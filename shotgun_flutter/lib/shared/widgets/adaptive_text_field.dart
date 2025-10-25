import 'package:flutter/material.dart';
import 'dart:io';

class AdaptiveTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final TextInputAction? textInputAction;

  const AdaptiveTextField({
    required this.controller,
    this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
    this.obscureText = false,
    this.textInputAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Mobile: larger text, more padding
    final isMobile = Platform.isAndroid || Platform.isIOS;

    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      obscureText:
          obscureText && maxLines == 1, // Only allow obscure when single line
      textInputAction: textInputAction,
      style: TextStyle(
        fontSize: isMobile ? 16 : 14, // iOS: 16+ для prevent zoom
      ),
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 12,
          vertical: isMobile ? 12 : 8,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 12 : 4),
        ),
      ),
    );
  }
}
