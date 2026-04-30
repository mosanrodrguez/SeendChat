import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/colors.dart';
import '../models/message.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMine;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm').format(message.createdAt);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 280),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isMine
                    ? (isDark ? const Color(0xFF1A1A1A) : SeendColors.bubbleSent)
                    : SeendColors.bubbleReceived,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Reply preview
                  if (message.replyText != null)
                    Container(
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        message.replyText!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isMine
                              ? SeendColors.textSecondary
                              : Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  // Text
                  if (message.text != null)
                    Text(
                      message.text!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isMine
                            ? SeendColors.textPrimary
                            : Colors.white,
                      ),
                    ),
                  const SizedBox(height: 2),
                  // Time + Status
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 10,
                          color: isMine ? SeendColors.textSecondary : Colors.white70,
                        ),
                      ),
                      if (isMine) ...[
                        const SizedBox(width: 3),
                        _buildStatusIcon(),
                      ],
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

  Widget _buildStatusIcon() {
    switch (message.status) {
      case 'sending':
        return const Icon(Icons.access_time, size: 14, color: SeendColors.checkGray);
      case 'sent':
        return const Icon(Icons.check, size: 14, color: SeendColors.checkGray);
      case 'delivered':
        return const Icon(Icons.done_all, size: 14, color: SeendColors.checkGray);
      case 'read':
        return const Icon(Icons.done_all, size: 14, color: SeendColors.checkBlue);
      default:
        return const SizedBox.shrink();
    }
  }
}
