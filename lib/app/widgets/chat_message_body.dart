import 'package:flutter/material.dart';
import 'package:salonhub_v2/app/widgets/app_photo.dart';

/// Isi pesan chat: URL foto dirender sebagai gambar, teks biasa sebagai teks.
class ChatMessageBody extends StatelessWidget {
  const ChatMessageBody({
    super.key,
    required this.text,
    required this.textColor,
    this.textStyle,
  });

  final String text;
  final Color textColor;
  final TextStyle? textStyle;

  bool get _isPhoto =>
      text.startsWith('http') &&
      (text.contains('/storage/v1/object/') || text.endsWith('.jpg'));

  @override
  Widget build(BuildContext context) {
    if (!_isPhoto) {
      return Text(
        text,
        style:
            textStyle ?? TextStyle(color: textColor, fontSize: 12, height: 1.4),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AppPhoto(text, width: 180, height: 180, fit: BoxFit.cover),
    );
  }
}
