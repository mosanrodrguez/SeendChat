import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/call_provider.dart';
import '../config/colors.dart';
import 'chat_screen.dart';
import 'call_screen.dart';

class ContactProfileScreen extends StatelessWidget {
  final String userId;
  final String userName;
  final String? userPhoto;
  final String? userPhone;
  final String? userInfo;

  const ContactProfileScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.userPhoto,
    this.userPhone,
    this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Avatar grande
          Center(
            child: CircleAvatar(
              radius: 56,
              backgroundColor: SeendColors.primary,
              backgroundImage: userPhoto != null ? NetworkImage(userPhoto!) : null,
              child: userPhoto == null ? Text(userName.isNotEmpty ? userName[0].toUpperCase() : '?', style: const TextStyle(fontSize: 40, color: Colors.white)) : null,
            ),
          ),
          const SizedBox(height: 16),
          // Nombre
          Center(child: Text(userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
          const SizedBox(height: 8),
          // Info
          Center(child: Text(userInfo ?? '¡Hola! Estoy usando Seend.', style: const TextStyle(fontSize: 14, color: SeendColors.textSecondary))),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          // Teléfono
          if (userPhone != null) ...[
            _buildInfoRow(Icons.phone, 'Teléfono', userPhone!),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 24),
          // Botón Enviar mensaje
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(userId: userId, userName: userName, userPhoto: userPhoto))),
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              label: const Text('Enviar mensaje', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 12),
          // Botón Llamar
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<CallProvider>().startCall(userId, userName, callerPhoto: userPhoto);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen()));
              },
              icon: const Icon(Icons.call, size: 18),
              label: const Text('Llamar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: SeendColors.textSecondary),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 11, color: SeendColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 15)),
        ]),
      ],
    );
  }
}
