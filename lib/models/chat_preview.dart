import 'message.dart';

class ChatPreview {
  final String chatId;
  final String? userId;
  final String? groupId;
  final String? channelId;
  final String displayName;
  final String? photoUrl;
  final String lastMessage;
  final String? lastSenderName;
  final DateTime? lastMessageTime;
  final String? lastStatus;
  final int unreadCount;
  final bool isOnline;
  final ChatType type;

  ChatPreview({
    required this.chatId,
    this.userId,
    this.groupId,
    this.channelId,
    required this.displayName,
    this.photoUrl,
    required this.lastMessage,
    this.lastSenderName,
    this.lastMessageTime,
    this.lastStatus,
    this.unreadCount = 0,
    this.isOnline = false,
    required this.type,
  });

  factory ChatPreview.fromMessage(Message msg, String currentUserId) {
    final isMe = msg.senderId == currentUserId;
    final displayName = msg.senderName;
    return ChatPreview(
      chatId: msg.senderId,
      userId: msg.senderId,
      displayName: displayName,
      lastMessage: (isMe ? 'Tú: ' : '') + (msg.text ?? (msg.imageUrl != null ? '📷 Imagen' : msg.voiceUrl != null ? '🎤 Nota de voz' : '')),
      lastSenderName: isMe ? 'Tú' : msg.senderName,
      lastMessageTime: msg.createdAt,
      lastStatus: msg.status,
      type: ChatType.direct,
    );
  }

  factory ChatPreview.fromJson(Map<String, dynamic> json) {
    return ChatPreview(
      chatId: json['chatId'] ?? json['userId'] ?? '',
      userId: json['userId'],
      groupId: json['groupId'],
      channelId: json['channelId'],
      displayName: json['displayName'] ?? json['fullName'] ?? '',
      photoUrl: json['photoUrl'],
      lastMessage: json['lastMessage'] ?? '',
      lastSenderName: json['lastSenderName'],
      lastMessageTime: json['lastMessageTime'] != null ? DateTime.parse(json['lastMessageTime']) : null,
      lastStatus: json['lastStatus'],
      unreadCount: json['unreadCount'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      type: ChatType.values.firstWhere((t) => t.name == (json['type'] ?? 'direct'), orElse: () => ChatType.direct),
    );
  }
}

enum ChatType { direct, group, channel }
