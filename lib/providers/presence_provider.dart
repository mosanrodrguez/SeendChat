import 'package:flutter/material.dart';

class UserPresence {
  final bool isOnline;
  final bool isTyping;
  final DateTime lastSeen;

  UserPresence({
    required this.isOnline,
    this.isTyping = false,
    required this.lastSeen,
  });
}

class PresenceProvider extends ChangeNotifier {
  final Map<String, UserPresence> _presences = {};

  UserPresence? getPresence(String userId) => _presences[userId];

  void updatePresence(String userId, UserPresence presence) {
    _presences[userId] = presence;
    notifyListeners();
  }

  void setOnline(String userId, bool online) {
    _presences[userId] = UserPresence(
      isOnline: online,
      lastSeen: online ? DateTime.now() : (_presences[userId]?.lastSeen ?? DateTime.now()),
    );
    notifyListeners();
  }

  void setTyping(String userId, bool typing) {
    final current = _presences[userId];
    if (current != null) {
      _presences[userId] = UserPresence(
        isOnline: current.isOnline,
        isTyping: typing,
        lastSeen: current.lastSeen,
      );
      notifyListeners();
    }
  }

  String getStatusText(String userId) {
    final presence = _presences[userId];
    if (presence == null) return 'Desconectado';
    if (presence.isOnline) return 'En línea';
    if (presence.isTyping) return 'Escribiendo...';

    final now = DateTime.now();
    final diff = now.difference(presence.lastSeen);

    if (diff.inMinutes < 1) return 'Últ. vez ahora';
    if (diff.inMinutes < 60) return 'Últ. vez hoy ${_formatTime(presence.lastSeen)}';
    if (diff.inDays < 1) return 'Últ. vez ayer';
    if (diff.inDays < 7) return 'Últ. vez hace ${diff.inDays} días';
    return 'Últ. vez ${presence.lastSeen.day}/${presence.lastSeen.month}/${presence.lastSeen.year.toString().substring(2)}';
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
