import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/chat_preview.dart';
import '../services/api_service.dart';
import '../services/local_db.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatPreview> _chats = [];
  Map<String, List<Message>> _messages = {};
  bool _isLoading = false;

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
        for (final chat in _chats) {
          await LocalDB.saveChat(chat);
        }
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<List<Message>> loadMessages(String chatId) async {
    _messages[chatId] = await LocalDB.getMessages(chatId);
    notifyListeners();

    try {
      final response = await ApiService.getMessages(chatId);
      if (response is List) {
        _messages[chatId] = response.map((m) => Message.fromJson(m)).toList();
        for (final msg in _messages[chatId]!) {
          await LocalDB.saveMessage(msg);
        }
        notifyListeners();
      }
    } catch (_) {}
    return _messages[chatId] ?? [];
  }

  void addMessageLocal(Message msg) {
    final chatId = msg.senderId;
    _messages[chatId] = [...(_messages[chatId] ?? []), msg];
    LocalDB.saveMessage(msg);
    notifyListeners();
    _updateChatPreview(msg);
  }

  void updateMessageStatus(String messageId, String status) {
    LocalDB.updateMessageStatus(messageId, status);
    for (final entry in _messages.entries) {
      for (final msg in entry.value) {
        if (msg.id == messageId) {
          msg.status = status;
          notifyListeners();
          return;
        }
      }
    }
  }

  void _updateChatPreview(Message msg) {
    final preview = ChatPreview.fromMessage(msg, msg.receiverId);
    final index = _chats.indexWhere((c) => c.chatId == msg.senderId);
    if (index >= 0) {
      _chats[index] = preview;
    } else {
      _chats.insert(0, preview);
    }
    LocalDB.saveChat(preview);
    notifyListeners();
  }

  Future<void> sendMessage(String receiverId, String text) async {
    await ApiService.sendMessage({
      'receiverId': receiverId,
      'text': text,
    });
  }
}
