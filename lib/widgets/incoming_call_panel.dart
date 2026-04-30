import 'package:flutter/material.dart';
import '../config/colors.dart';

class IncomingCallPanel extends StatelessWidget {
  final String callerName;
  final String? callerPhoto;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const IncomingCallPanel({
    super.key,
    required this.callerName,
    this.callerPhoto,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: SeendColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: SeendColors.primary,
            backgroundImage: callerPhoto != null ? NetworkImage(callerPhoto!) : null,
            child: callerPhoto == null
                ? Text(
                    callerName.isNotEmpty ? callerName[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          // Name + Status
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Llamada de $callerName',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Llamada entrante...',
                  style: TextStyle(fontSize: 11, color: SeendColors.textSecondary),
                ),
              ],
            ),
          ),
          // Accept
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: SeendColors.online,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.call, color: Colors.white, size: 20),
              onPressed: onAccept,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 8),
          // Reject
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: SeendColors.error,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.call_end, color: Colors.white, size: 20),
              onPressed: onReject,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
