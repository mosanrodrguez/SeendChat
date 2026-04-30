import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserPresence {
  final bool isOnline;
  final bool isTyping;
  final bool isRecording;
  final DateTime lastSeen;

  UserPresence({
    required this.isOnline,
    this.isTyping = false,
    this.isRecording = false,
    required this.lastSeen,
  });
}

class PresenceProvider extends ChangeNotifier {
  final Map<String, UserPresence> _presences = {};
  String _connectionStatus = 'connecting';
  Timer? _pingTimer;

  PresenceProvider() {
    _startPing();
  }

  String get connectionStatus => _connectionStatus;
  bool get isOnline => _connectionStatus == 'online';

  void _startPing() {
    _pingTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final online = await ApiService.isServerOnline();
      _connectionStatus = online ? 'online' : 'offline';
      notifyListeners();
    });
  }

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
    if (presence == null) return '';
    if (presence.isTyping) return 'Escribiendo...';
    if (presence.isRecording) return 'Grabando audio...';
    if (presence.isOnline) return 'En línea';

    final now = DateTime.now();
    final diff = now.difference(presence.lastSeen);

    if (diff.inMinutes < 1) return 'Últ. vez ahora';
    if (diff.inMinutes < 60) return 'Últ. vez hoy ${_formatTime(presence.lastSeen)}';
    if (diff.inHours < 24) return 'Últ. vez ayer';
    return 'Últ. vez ${presence.lastSeen.day}/${presence.lastSeen.month}/${presence.lastSeen.year.toString().substring(2)}';
  }

  String _formatTime(DateTime t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _pingTimer?.cancel();
    super.dispose();
  }
}
