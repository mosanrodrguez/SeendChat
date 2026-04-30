import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/colors.dart';
import '../models/message.dart';
import 'message_image.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMine;

  const ChatBubble({super.key, required this.message, required this.isMine});

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm').format(message.createdAt);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isMine
                    ? (isDark ? SeendColors.bubbleSentDark : SeendColors.bubbleSent)
                    : (isDark ? SeendColors.bubbleReceivedDark : SeendColors.bubbleReceived),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isMine ? 12 : 0),
                  bottomRight: Radius.circular(isMine ? 0 : 12),
                ),
              ),
              child: Column(
                crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Imagen
                  if (message.imageUrl != null)
                    MessageImage(
                      imageUrl: message.imageUrl,
                      imageSize: message.imageSize,
                      isMine: isMine,
                      isDownloaded: !isMine,
                      isUploading: message.status == 'sending',
                    ),
                  // Reply
                  if (message.replyText != null)
                    Container(
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.only(top: 4, bottom: 4),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
                      child: Text(message.replyText!, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: isMine ? SeendColors.textSecondary : Colors.white70)),
                    ),
                  // Texto
                  if (message.text != null)
                    Text(message.text!, style: TextStyle(fontSize: 14, color: isMine ? SeendColors.textPrimary : Colors.white)),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(timeStr, style: TextStyle(fontSize: 10, color: isMine ? SeendColors.textSecondary : Colors.white60)),
                      if (isMine) ...[const SizedBox(width: 3), _buildStatus()],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatus() {
    switch (message.status) {
      case 'sending':
        return const Icon(Icons.access_time, size: 13, color: SeendColors.checkGray);
      case 'sent':
        return const Icon(Icons.check, size: 13, color: SeendColors.checkGray);
      case 'delivered':
        return const Icon(Icons.done_all, size: 13, color: SeendColors.checkGray);
      case 'read':
        return const Icon(Icons.done_all, size: 13, color: SeendColors.checkBlue);
      default:
        return const SizedBox.shrink();
    }
  }
}
