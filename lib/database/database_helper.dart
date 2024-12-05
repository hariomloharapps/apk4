
// lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/chat_message.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'chat_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT NOT NULL,
        isSent INTEGER NOT NULL,
        timestamp TEXT NOT NULL,
        attachmentUrl TEXT,
        messageStatus TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        startTime TEXT NOT NULL,
        endTime TEXT,
        title TEXT
      )
    ''');

  }

  // Message operations
  Future<int> insertMessage(ChatMessage message) async {
    final db = await database;
    return await db.insert('messages', message.toMap());
  }

  Future<List<ChatMessage>> getMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('messages',
        orderBy: 'timestamp ASC');
    return List.generate(maps.length, (i) => ChatMessage.fromMap(maps[i]));
  }

  Future<void> deleteMessage(int id) async {
    final db = await database;
    await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllMessages() async {
    final db = await database;
    await db.delete('messages');
  }
}
