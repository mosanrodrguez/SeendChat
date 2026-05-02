import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../models/chat_preview.dart';

class AvatarWithBadge extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final ChatType type;
  final double size;
  final bool showOnline;
  final bool isOnline;

  const AvatarWithBadge({
    super.key,
    required this.name,
    this.photoUrl,
    required this.type,
    this.size = 48,
    this.showOnline = false,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: SeendColors.primary,
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
          child: photoUrl == null
              ? Icon(type == ChatType.group ? Icons.groups : Icons.person, color: Colors.white, size: size * 0.5)
              : null,
        ),
        if (type == ChatType.group)
          Positioned(
            bottom: -2, right: -2,
            child: Container(
              width: size * 0.4, height: size * 0.4,
              decoration: BoxDecoration(color: SeendColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
              child: Icon(Icons.groups, color: Colors.white, size: size * 0.22),
            ),
          ),
        if (showOnline && isOnline)
          Positioned(bottom: 0, right: 0, child: Container(width: size * 0.25, height: size * 0.25, decoration: BoxDecoration(color: SeendColors.online, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)))),
      ],
    );
  }
}
