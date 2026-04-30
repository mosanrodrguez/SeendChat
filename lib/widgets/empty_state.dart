import 'package:flutter/material.dart';
import '../config/colors.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonText,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: SeendColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: SeendColors.primary),
            ),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!, style: const TextStyle(fontSize: 14, color: SeendColors.textSecondary), textAlign: TextAlign.center),
            ],
            if (buttonText != null && onButtonTap != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onButtonTap,
                icon: const Icon(Icons.add, size: 18),
                label: Text(buttonText!, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
