import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/auth_provider.dart';
import '../config/colors.dart';
import 'edit_profile_screen.dart';
import 'welcome_screen.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final link = auth.chatLink;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Mi perfil', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white, size: 22),
            onPressed: () => Share.share('Contáctame en Seend: $link', subject: 'Mi perfil de Seend'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(child: CircleAvatar(radius: 48, backgroundColor: SeendColors.primary, child: Text(auth.fullName?.isNotEmpty == true ? auth.fullName![0].toUpperCase() : '?', style: const TextStyle(fontSize: 32, color: Colors.white)))),
          const SizedBox(height: 12),
          Center(child: Text(auth.fullName ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          Center(child: Text('@${auth.username ?? ''}', style: const TextStyle(fontSize: 14, color: SeendColors.textSecondary))),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)), child: const Text('¡Hola! Estoy usando Seend.', style: TextStyle(fontSize: 14))),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          const Text('Número de teléfono', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary)),
          const SizedBox(height: 4),
          Text(auth.phoneNumber ?? '', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())), child: const Text('EDITAR PERFIL', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, height: 48, child: OutlinedButton(onPressed: () { auth.logout(); Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()), (r) => false); }, style: OutlinedButton.styleFrom(foregroundColor: SeendColors.error, side: const BorderSide(color: SeendColors.error)), child: const Text('CERRAR SESIÓN', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
        ],
      ),
    );
  }
}
