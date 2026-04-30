import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/chat_preview.dart';
import '../services/api_service.dart';
import '../services/local_db.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatPreview> _chats = [];
  Map<String, List<Message>> _messages = {};
  bool _isLoading = false;
  Map<String, bool> _hasMore = {};

  List<ChatPreview> get chats => _chats;
  Map<String, List<Message>> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> loadChats() async {
    _chats = await LocalDB.getChats();
    notifyListeners();
    try {
      final response = await ApiService.getChats();
      if (response is List) {
        _chats = response.map((c) => ChatPreview.fromJson(c)).toList();
        for (final chat in _chats) await LocalDB.saveChat(chat);
        notifyListeners();
      }
    } catch (_) {}
  }

  // Chat individual/grupo: NO carga historial
  Future<List<Message>> loadMessages(String chatId, {bool isChannel = false}) async {
    if (!isChannel) {
      _messages[chatId] = [];
      notifyListeners();
      return [];
    }
    // Solo canales cargan historial
    return loadChannelMessages(chatId);
  }

  // Canal: carga últimos 10 mensajes
  Future<List<Message>> loadChannelMessages(String channelId, {bool loadMore = false}) async {
    if (!loadMore) _messages[channelId] = [];

    try {
      final page = loadMore ? (_messages[channelId]?.length ?? 0) : 0;
      final response = await ApiService.get('messages/$channelId?page=$page&limit=10');
      if (response is List && response.isNotEmpty) {
        final msgs = response.map((m) => Message.fromJson(m)).toList();
        if (loadMore) {
          _messages[channelId] = [...msgs, ...(_messages[channelId] ?? [])];
        } else {
          _messages[channelId] = msgs;
        }
        _hasMore[channelId] = msgs.length >= 10;
        notifyListeners();
      } else {
        _hasMore[channelId] = false;
      }
    } catch (_) {}
    return _messages[channelId] ?? [];
  }

  bool hasMoreMessages(String channelId) => _hasMore[channelId] ?? false;

  void addMessageLocal(Message msg) {
    final chatId = msg.isGroup == true ? (msg.groupId ?? msg.receiverId) : (msg.senderId == msg.receiverId ? msg.receiverId : msg.senderId);
    _messages[chatId] = [...(_messages[chatId] ?? []), msg];
    LocalDB.saveMessage(msg);
    notifyListeners();
    _updateChatPreview(msg);
  }

  void updateMessageStatus(String messageId, String status) {
    LocalDB.updateMessageStatus(messageId, status);
    for (final entry in _messages.entries) {
      for (final msg in entry.value) {
        if (msg.id == messageId) { msg.status = status; notifyListeners(); return; }
      }
    }
  }

  void _updateChatPreview(Message msg) {
    final preview = ChatPreview.fromMessage(msg, msg.receiverId);
    final index = _chats.indexWhere((c) => c.chatId == msg.senderId);
    if (index >= 0) _chats[index] = preview; else _chats.insert(0, preview);
    LocalDB.saveChat(preview);
    notifyListeners();
  }
}
