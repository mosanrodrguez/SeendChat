import 'package:flutter/material.dart';
import '../config/colors.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const EmptyState({super.key, required this.icon, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 80, height: 80, decoration: BoxDecoration(color: SeendColors.primary.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, size: 40, color: SeendColors.primary)),
      const SizedBox(height: 20),
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
      if (subtitle != null) ...[const SizedBox(height: 8), Text(subtitle!, style: const TextStyle(fontSize: 14, color: SeendColors.textSecondary), textAlign: TextAlign.center)],
    ])));
  }
}
