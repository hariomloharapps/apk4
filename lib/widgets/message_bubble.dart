import 'package:flutter/material.dart';
import 'dart:convert';
import '../Config/global_state.dart';
import '../models/chat_message.dart';
// import '../path_to_global_state/global_state.dart'; // Adjust this import path

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  // Define default purple color as static const
  static const Color defaultPurple = Color(0xFF9C27B0);

  const MessageBubble({required this.message});

  String _processMessageText(String text) {
    if (text.isEmpty) return '';

    try {
      final decodedText = utf8.decode(text.runes.toList(), allowMalformed: true);
      return decodedText
          .replaceAll(r'\u', '\\u')
          .replaceAll(r'\\n', '\n');
    } catch (e) {
      debugPrint('Message processing error: $e');
      return text;
    }
  }

  Color _getGlowColor() {
    // Only for received messages (not sent by user)
    if (!message.isSent) {
      String? globalColor = GlobalState().color;
      if (globalColor != null) {
        // Convert the stored color string to Color object
        try {
          return Color(int.parse(globalColor));
        } catch (e) {
          return defaultPurple;
        }
      }
      return defaultPurple;
    }
    return Colors.black; // No glow for sent messages
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = _getGlowColor();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment:
        message.isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            message.isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: message.isSent
                          ? const Color(0xFF2C2C2E)
                          : const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: message.isSent
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                        bottomLeft: !message.isSent
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                      ),
                      // Only add border and glow for received messages
                      border: !message.isSent ? Border.all(
                        color: glowColor,
                        width: 1.0,
                      ) : null,
                      boxShadow: [
                        if (!message.isSent) // Only add glow effect for received messages
                          BoxShadow(
                            color: glowColor,
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      _processMessageText(message.text),
                      style: TextStyle(
                        color: message.isSent ? Colors.white : Colors.grey[300],
                        fontSize: 16,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.left,
                      softWrap: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}