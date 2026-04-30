class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String? text;
  final String? imageUrl;
  final String? videoUrl;
  final String? voiceUrl;
  final int? imageSize;
  final int? voiceDuration;
  final String? replyTo;
  final String? replyText;
  String status;
  final DateTime createdAt;
  final bool isGroup;
  final String? groupId;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    this.text,
    this.imageUrl,
    this.videoUrl,
    this.voiceUrl,
    this.imageSize,
    this.voiceDuration,
    this.replyTo,
    this.replyText,
    this.status = 'sending',
    required this.createdAt,
    this.isGroup = false,
    this.groupId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      receiverId: json['receiverId'] ?? '',
      text: json['text'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      voiceUrl: json['voiceUrl'],
      imageSize: json['imageSize'],
      voiceDuration: json['voiceDuration'],
      replyTo: json['replyTo'],
      replyText: json['replyText'],
      status: json['status'] ?? 'sent',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      isGroup: json['isGroup'] ?? false,
      groupId: json['groupId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'senderName': senderName,
    'receiverId': receiverId,
    'text': text,
    'imageUrl': imageUrl,
    'videoUrl': videoUrl,
    'voiceUrl': voiceUrl,
    'imageSize': imageSize,
    'voiceDuration': voiceDuration,
    'replyTo': replyTo,
    'replyText': replyText,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'isGroup': isGroup,
    'groupId': groupId,
  };

  // Estados
  bool get isSending => status == 'sending';
  bool get isSent => status == 'sent';
  bool get isDelivered => status == 'delivered';
  bool get isRead => status == 'read';
}
