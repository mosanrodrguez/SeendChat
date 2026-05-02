import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/auth_provider.dart';
import '../config/colors.dart';
import '../config/api_config.dart';
import 'my_profile_screen.dart';
import 'account_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final link = ApiConfig.profileUrl(auth.username ?? '');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Ajustes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Center(child: Column(children: [
          CircleAvatar(radius: 48, backgroundColor: SeendColors.primary, child: Text(auth.fullName?.isNotEmpty == true ? auth.fullName![0].toUpperCase() : '?', style: const TextStyle(fontSize: 32, color: Colors.white))),
          const SizedBox(height: 12),
          Text(auth.fullName ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${auth.phoneNumber ?? ''} • @${auth.username ?? ''}', style: const TextStyle(fontSize: 13, color: SeendColors.textSecondary)),
        ])),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: _buildOption(Icons.person, 'Mi perfil', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyProfileScreen())))),
          const SizedBox(width: 16),
          Expanded(child: _buildOption(Icons.share, 'Compartir', () => Share.share('Contáctame en Seend: $link'))),
        ]),
        const SizedBox(height: 24),
        const Divider(),
        ListTile(leading: const Icon(Icons.account_circle, color: SeendColors.primary), title: const Text('Cuenta'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen()))),
        ListTile(leading: const Icon(Icons.storage, color: SeendColors.primary), title: const Text('Datos y almacenamiento'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        ListTile(leading: const Icon(Icons.lock, color: SeendColors.primary), title: const Text('Privacidad'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
      ]),
    );
  }

  Widget _buildOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(border: Border.all(color: SeendColors.border), borderRadius: BorderRadius.circular(8)),
        child: Column(children: [Icon(icon, color: SeendColors.primary, size: 22), const SizedBox(height: 4), Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500))]),
      ),
    );
  }
}
