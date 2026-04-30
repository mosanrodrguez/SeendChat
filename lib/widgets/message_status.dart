import 'package:flutter/material.dart';
import '../config/colors.dart';

class MessageStatus extends StatelessWidget {
  final String status;

  const MessageStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
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
