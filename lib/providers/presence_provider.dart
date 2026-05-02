import 'package:flutter/material.dart';

class UserPresence { final bool isOnline; final bool isTyping; final DateTime lastSeen;
  UserPresence({required this.isOnline, this.isTyping = false, required this.lastSeen}); }

class PresenceProvider extends ChangeNotifier {
  final Map<String, UserPresence> _presences = {};
  String _connectionStatus = 'connecting';
  bool get isOnline => _connectionStatus == 'online';
  String get connectionStatus => _connectionStatus;

  void updateConnection(String status) { _connectionStatus = status; notifyListeners(); }
  UserPresence? getPresence(String userId) => _presences[userId];
  void updatePresence(String userId, UserPresence presence) { _presences[userId] = presence; notifyListeners(); }
  void setTyping(String userId, bool typing) { final c = _presences[userId]; if (c != null) { _presences[userId] = UserPresence(isOnline: c.isOnline, isTyping: typing, lastSeen: c.lastSeen); notifyListeners(); } }

  String getStatusText(String userId) {
    final p = _presences[userId]; if (p == null) return ''; if (p.isTyping) return 'Escribiendo...'; if (p.isOnline) return 'En línea';
    final now = DateTime.now(); final diff = now.difference(p.lastSeen);
    if (diff.inMinutes < 1) return 'Últ. vez ahora'; if (diff.inMinutes < 60) return 'Últ. vez hoy ${p.lastSeen.hour}:${p.lastSeen.minute.toString().padLeft(2, '0')}';
    if (diff.inHours < 24) return 'Últ. vez ayer'; if (diff.inDays < 7) return 'Últ. vez hace ${diff.inDays} días';
    return 'Últ. vez ${p.lastSeen.day}/${p.lastSeen.month}/${p.lastSeen.year.toString().substring(2)}';
  }
}
