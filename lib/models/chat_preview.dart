import 'message.dart';

class ChatPreview {
  final String chatId; final String? userId; final String? groupId;
  final String displayName; final String? photoUrl;
  final String lastMessage; final String? lastSenderName; final DateTime? lastMessageTime;
  final String? lastStatus; final int unreadCount; final bool isOnline; final ChatType type;

  ChatPreview({required this.chatId, this.userId, this.groupId, required this.displayName, this.photoUrl, required this.lastMessage, this.lastSenderName, this.lastMessageTime, this.lastStatus, this.unreadCount = 0, this.isOnline = false, required this.type});

  factory ChatPreview.fromMessage(Message msg, String currentUserId) {
    final isMe = msg.senderId == currentUserId;
    return ChatPreview(chatId: msg.senderId, userId: msg.senderId, displayName: msg.senderName, lastMessage: (isMe ? 'Tú: ' : '') + (msg.text ?? (msg.imageUrl != null ? '📷 Imagen' : msg.voiceUrl != null ? '🎤 Nota de voz' : '')), lastSenderName: isMe ? 'Tú' : msg.senderName, lastMessageTime: msg.createdAt, lastStatus: msg.status, type: ChatType.direct);
  }

  factory ChatPreview.fromJson(Map<String, dynamic> j) => ChatPreview(chatId: j['chatId'] ?? j['userId'] ?? '', userId: j['userId'], groupId: j['groupId'], displayName: j['displayName'] ?? j['fullName'] ?? '', photoUrl: j['photoUrl'], lastMessage: j['lastMessage'] ?? '', lastSenderName: j['lastSenderName'], lastMessageTime: j['lastMessageTime'] != null ? DateTime.parse(j['lastMessageTime']) : null, lastStatus: j['lastStatus'], unreadCount: j['unreadCount'] ?? 0, isOnline: j['isOnline'] ?? false, type: ChatType.values.firstWhere((t) => t.name == (j['type'] ?? 'direct'), orElse: () => ChatType.direct));
}

enum ChatType { direct, group }
