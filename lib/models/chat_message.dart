class ChatMessage {
  final int? id;
  final String text;
  final bool isSent;
  final DateTime timestamp;
  final String? attachmentUrl;
  final String? messageStatus;

  ChatMessage({
    this.id,
    required this.text,
    required this.isSent,
    required this.timestamp,
    this.attachmentUrl,
    this.messageStatus,
  });

  String get processedText {
    try {
      // First try to decode HTML entities if any
      String processed = text
          .replaceAll('&quot;', '"')
          .replaceAll('&#x27;', "'")
          .replaceAll('&amp;', '&');

      // Remove any surrounding quotes
      if (processed.startsWith('"') && processed.endsWith('"')) {
        processed = processed.substring(1, processed.length - 1);
      }

      // Handle escaped unicode
      RegExp regex = RegExp(r'\\u([0-9a-fA-F]{4})');
      processed = processed.replaceAllMapped(regex, (Match match) {
        try {
          return String.fromCharCode(
              int.parse(match.group(1)!, radix: 16));
        } catch (e) {
          return match.group(0)!;
        }
      });

      return processed;
    } catch (e) {
      return text;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isSent': isSent ? 1 : 0,
      'timestamp': timestamp.toIso8601String(),
      'attachmentUrl': attachmentUrl,
      'messageStatus': messageStatus,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      text: map['text'],
      isSent: map['isSent'] == 1,
      timestamp: DateTime.parse(map['timestamp']),
      attachmentUrl: map['attachmentUrl'],
      messageStatus: map['messageStatus'],
    );
  }

  factory ChatMessage.fromApiResponse(Map<String, dynamic> json) {
    String response = json['response'] ?? '';
    if (response.startsWith('"') && response.endsWith('"')) {
      response = response.substring(1, response.length - 1);
    }

    return ChatMessage(
      text: response,
      isSent: false,
      timestamp: DateTime.now(),
      messageStatus: 'received',
    );
  }
}