import 'package:flutter/material.dart';
import '../config/colors.dart';

class ContactProfileScreen extends StatelessWidget {
  final String userId; final String userName;
  final String? userPhoto; final String? userPhone; final String? userInfo;
  final String? username;

  const ContactProfileScreen({
    super.key,
    required this.userId, required this.userName,
    this.userPhoto, this.userPhone, this.userInfo, this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Perfil', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Center(child: CircleAvatar(radius: 56, backgroundColor: SeendColors.primary, child: Text(userName.isNotEmpty ? userName[0].toUpperCase() : '?', style: const TextStyle(fontSize: 40, color: Colors.white)))),
        const SizedBox(height: 16),
        Center(child: Text(userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        if (username != null) Center(child: Text('@$username', style: const TextStyle(fontSize: 14, color: SeendColors.textSecondary))),
        const SizedBox(height: 8),
        Center(child: Text(userInfo ?? '¡Hola! Estoy usando Seend.', style: const TextStyle(fontSize: 14, color: SeendColors.textSecondary))),
        const SizedBox(height: 24),
        const Divider(),
        if (userPhone != null) ...[
          const SizedBox(height: 16),
          _buildInfoRow(Icons.phone, 'Teléfono', userPhone!),
        ],
        const SizedBox(height: 32),
      ]),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 20, color: SeendColors.textSecondary),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: SeendColors.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 15)),
      ]),
    ]);
  }
}
