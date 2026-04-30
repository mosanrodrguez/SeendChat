import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../config/colors.dart';
import '../config/api_config.dart';

class BotProfileScreen extends StatelessWidget {
  final String botId;
  final String botName;
  final String? botAvatar;
  final String? botUsername;
  final String? botDescription;

  const BotProfileScreen({
    super.key,
    required this.botId,
    required this.botName,
    this.botAvatar,
    this.botUsername,
    this.botDescription,
  });

  @override
  Widget build(BuildContext context) {
    final link = '${ApiConfig.baseUrl}/bot/${botUsername ?? botId}';
    // Limpiar URL para mostrar
    final cleanLink = 'https://chat.seend.com/bot/${botUsername ?? botId}';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Perfil del bot', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white, size: 22),
            onPressed: () => Share.share(
              'Chatea con $botName en Seend: $cleanLink',
              subject: 'Bot de Seend',
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Avatar
          Center(
            child: CircleAvatar(
              radius: 56,
              backgroundColor: SeendColors.primary,
              child: Text(
                botName.isNotEmpty ? botName[0].toUpperCase() : '🤖',
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Nombre
          Center(
            child: Text(
              botName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          // Username
          if (botUsername != null)
            Center(
              child: Text(
                '@$botUsername',
                style: const TextStyle(fontSize: 14, color: SeendColors.textSecondary),
              ),
            ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          // Info / Descripción
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              botDescription ?? 'Sin descripción.',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
