import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/message.dart';
import '../models/chat_preview.dart';

class LocalDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'seendchat.db');
    return openDatabase(path, version: 1, onCreate: (db, v) async {
      await db.execute('''
        CREATE TABLE messages (
          id TEXT PRIMARY KEY,
          senderId TEXT,
          senderName TEXT,
          receiverId TEXT,
          text TEXT,
          imageUrl TEXT,
          videoUrl TEXT,
          voiceUrl TEXT,
          imageSize INTEGER,
          voiceDuration INTEGER,
          replyTo TEXT,
          replyText TEXT,
          status TEXT,
          createdAt TEXT,
          isGroup INTEGER DEFAULT 0,
          groupId TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE chats (
          chatId TEXT PRIMARY KEY,
          userId TEXT,
          groupId TEXT,
          channelId TEXT,
          displayName TEXT,
          photoUrl TEXT,
          lastMessage TEXT,
          lastSenderName TEXT,
          lastMessageTime TEXT,
          lastStatus TEXT,
          unreadCount INTEGER DEFAULT 0,
          isOnline INTEGER DEFAULT 0,
          type TEXT DEFAULT 'direct'
        )
      ''');
    });
  }

  // Mensajes
  static Future<void> saveMessage(Message msg) async {
    final db = await database;
    await db.insert('messages', msg.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Message>> getMessages(String chatId) async {
    final db = await database;
    final result = await db.query(
      'messages',
      where: 'senderId = ? OR receiverId = ?',
      whereArgs: [chatId, chatId],
      orderBy: 'createdAt ASC',
    );
    return result.map((m) => Message.fromJson(m)).toList();
  }

  static Future<void> updateMessageStatus(String id, String status) async {
    final db = await database;
    await db.update('messages', {'status': status}, where: 'id = ?', whereArgs: [id]);
  }

  // Chats
  static Future<void> saveChat(ChatPreview chat) async {
    final db = await database;
    await db.insert('chats', {
      'chatId': chat.chatId,
      'userId': chat.userId,
      'groupId': chat.groupId,
      'channelId': chat.channelId,
      'displayName': chat.displayName,
      'photoUrl': chat.photoUrl,
      'lastMessage': chat.lastMessage,
      'lastSenderName': chat.lastSenderName,
      'lastMessageTime': chat.lastMessageTime?.toIso8601String(),
      'lastStatus': chat.lastStatus,
      'unreadCount': chat.unreadCount,
      'isOnline': chat.isOnline ? 1 : 0,
      'type': chat.type.name,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<ChatPreview>> getChats() async {
    final db = await database;
    final result = await db.query('chats', orderBy: 'lastMessageTime DESC');
    return result.map((c) => ChatPreview(
      chatId: c['chatId'] as String,
      userId: c['userId'] as String?,
      groupId: c['groupId'] as String?,
      channelId: c['channelId'] as String?,
      displayName: c['displayName'] as String? ?? '',
      photoUrl: c['photoUrl'] as String?,
      lastMessage: c['lastMessage'] as String? ?? '',
      lastSenderName: c['lastSenderName'] as String?,
      lastMessageTime: c['lastMessageTime'] != null ? DateTime.parse(c['lastMessageTime'] as String) : null,
      lastStatus: c['lastStatus'] as String?,
      unreadCount: c['unreadCount'] as int? ?? 0,
      isOnline: (c['isOnline'] as int? ?? 0) == 1,
      type: ChatType.values.firstWhere((t) => t.name == (c['type'] ?? 'direct'), orElse: () => ChatType.direct),
    )).toList();
  }
}
