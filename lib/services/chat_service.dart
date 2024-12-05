
// lib/services/chat_service.dart
import '../database/database_helper.dart';
import '../models/chat_message.dart';

class ChatService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> saveMessage(ChatMessage message) async {
    await _dbHelper.insertMessage(message);
  }

  Future<List<ChatMessage>> loadMessages() async {
    return await _dbHelper.getMessages();
  }

  Future<void> clearChat() async {
    await _dbHelper.clearAllMessages();
  }

  Future<void> deleteMessage(int messageId) async {
    await _dbHelper.deleteMessage(messageId);
  }
}