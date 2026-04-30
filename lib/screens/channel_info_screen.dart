import 'package:flutter/material.dart';
import '../config/colors.dart';

class ChannelInfoScreen extends StatelessWidget {
  final String channelId;
  final String channelName;
  const ChannelInfoScreen({super.key, required this.channelId, required this.channelName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Información del canal', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Center(child: CircleAvatar(radius: 40, backgroundColor: SeendColors.primary, child: const Icon(Icons.campaign, color: Colors.white, size: 36))),
        const SizedBox(height: 12),
        Center(child: Text(channelName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        Center(child: const Text('Canal · 2.450 suscriptores', style: TextStyle(fontSize: 13, color: SeendColors.textSecondary))),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)), child: const Text('Canal oficial para noticias y actualizaciones de la app.', style: TextStyle(fontSize: 14))),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 48, child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: SeendColors.error, side: const BorderSide(color: SeendColors.error)), child: const Text('SALIR DEL CANAL', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
      ]),
    );
  }
}
