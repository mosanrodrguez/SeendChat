class Message {
  final String id; final String senderId; final String senderName; final String receiverId;
  final String? text; final String? imageUrl; final String? videoUrl; final String? voiceUrl;
  final String? fileUrl; final String? fileName; final int? fileSize; final int? imageSize; final int? voiceDuration;
  final String? replyTo; final String? replyText; String status; final DateTime createdAt;
  final bool isGroup; final String? groupId;

  Message({required this.id, required this.senderId, required this.senderName, required this.receiverId, this.text, this.imageUrl, this.videoUrl, this.voiceUrl, this.fileUrl, this.fileName, this.fileSize, this.imageSize, this.voiceDuration, this.replyTo, this.replyText, this.status = 'sending', required this.createdAt, this.isGroup = false, this.groupId});

  factory Message.fromJson(Map<String, dynamic> j) => Message(id: j['id'] ?? '', senderId: j['senderId'] ?? '', senderName: j['senderName'] ?? '', receiverId: j['receiverId'] ?? '', text: j['text'], imageUrl: j['imageUrl'], videoUrl: j['videoUrl'], voiceUrl: j['voiceUrl'], fileUrl: j['fileUrl'], fileName: j['fileName'], fileSize: j['fileSize'], imageSize: j['imageSize'], voiceDuration: j['voiceDuration'], replyTo: j['replyTo'], replyText: j['replyText'], status: j['status'] ?? 'sent', createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt']) : DateTime.now(), isGroup: j['isGroup'] == true || j['isGroup'] == 1, groupId: j['groupId']);

  Map<String, dynamic> toJson() => {'id': id, 'senderId': senderId, 'senderName': senderName, 'receiverId': receiverId, 'text': text, 'imageUrl': imageUrl, 'videoUrl': videoUrl, 'voiceUrl': voiceUrl, 'fileUrl': fileUrl, 'fileName': fileName, 'fileSize': fileSize, 'imageSize': imageSize, 'voiceDuration': voiceDuration, 'replyTo': replyTo, 'replyText': replyText, 'status': status, 'createdAt': createdAt.toIso8601String(), 'isGroup': isGroup, 'groupId': groupId};
}
