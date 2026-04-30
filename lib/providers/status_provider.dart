import 'package:flutter/material.dart';

class StatusItem {
  final String id;
  final String userId;
  final String userName;
  final String? userPhoto;
  final String? imageUrl;
  final String? text;
  final DateTime createdAt;
  final DateTime expiresAt;
  final List<String> viewedBy;

  StatusItem({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhoto,
    this.imageUrl,
    this.text,
    required this.createdAt,
    required this.expiresAt,
    this.viewedBy = const [],
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours}h';
    if (diff.inDays < 1) return 'Ayer';
    return 'Hace ${diff.inDays}d';
  }
}

class StatusProvider extends ChangeNotifier {
  List<StatusItem> _myStatuses = [];
  List<StatusItem> _recentStatuses = [];
  List<StatusItem> _viewedStatuses = [];

  List<StatusItem> get myStatuses => _myStatuses.where((s) => !s.isExpired).toList();
  List<StatusItem> get recentStatuses => _recentStatuses.where((s) => !s.isExpired).toList();
  List<StatusItem> get viewedStatuses => _viewedStatuses.where((s) => !s.isExpired).toList();

  void addStatus(StatusItem status) {
    _myStatuses.insert(0, status);
    notifyListeners();
  }

  void markAsViewed(String statusId, String userId) {
    for (final status in [..._recentStatuses, ..._viewedStatuses]) {
      if (status.id == statusId && !status.viewedBy.contains(userId)) {
        status.viewedBy.add(userId);
        notifyListeners();
        break;
      }
    }
  }

  void loadDummyData() {
    final now = DateTime.now();
    _recentStatuses = [
      StatusItem(id: '1', userId: 'maria', userName: 'María García', imageUrl: null, text: '¡De vacaciones! 🌴', createdAt: now.subtract(const Duration(hours: 2)), expiresAt: now.add(const Duration(hours: 22))),
      StatusItem(id: '2', userId: 'carlos', userName: 'Carlos López', imageUrl: null, text: 'En el trabajo', createdAt: now.subtract(const Duration(minutes: 45)), expiresAt: now.add(const Duration(hours: 23))),
      StatusItem(id: '3', userId: 'laura', userName: 'Laura Martínez', imageUrl: null, text: 'Buenos días ☀️', createdAt: now.subtract(const Duration(hours: 5)), expiresAt: now.add(const Duration(hours: 19))),
    ];
    _viewedStatuses = [
      StatusItem(id: '4', userId: 'marta', userName: 'Marta Gómez', imageUrl: null, text: 'Feliz cumpleaños 🎂', createdAt: now.subtract(const Duration(hours: 5)), expiresAt: now.add(const Duration(hours: 19))),
      StatusItem(id: '5', userId: 'diego', userName: 'Diego Ruiz', imageUrl: null, text: '', createdAt: now.subtract(const Duration(hours: 8)), expiresAt: now.add(const Duration(hours: 16))),
    ];
    notifyListeners();
  }
}
