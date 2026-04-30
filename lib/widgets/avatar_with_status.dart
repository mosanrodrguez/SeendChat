import 'package:flutter/material.dart';
import '../config/colors.dart';

class AvatarWithStatus extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final double size;
  final bool isOnline;
  final bool showStatus;
  final IconData? badgeIcon;
  final VoidCallback? onTap;

  const AvatarWithStatus({
    super.key,
    this.photoUrl,
    required this.name,
    this.size = 48,
    this.isOnline = false,
    this.showStatus = true,
    this.badgeIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: size / 2,
            backgroundColor: SeendColors.primary,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
            child: photoUrl == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.4,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          if (badgeIcon != null)
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                width: size * 0.4,
                height: size * 0.4,
                decoration: BoxDecoration(
                  color: SeendColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Icon(badgeIcon!, color: Colors.white, size: size * 0.25),
              ),
            ),
        ],
      ),
    );
  }
}
