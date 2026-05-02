import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/colors.dart';
import 'edit_profile_screen.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Mi perfil', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
            child: const Text('Editar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Center(child: CircleAvatar(radius: 56, backgroundColor: SeendColors.primary, child: Text(auth.fullName?.isNotEmpty == true ? auth.fullName![0].toUpperCase() : '?', style: const TextStyle(fontSize: 40, color: Colors.white)))),
        const SizedBox(height: 16),
        Center(child: Text(auth.fullName ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        Center(child: Text(auth.info ?? '¡Hola! Estoy usando Seend.', style: const TextStyle(fontSize: 14, color: SeendColors.textSecondary))),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        _buildInfoRow(Icons.phone, 'Teléfono', auth.phoneNumber ?? ''),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.alternate_email, 'Usuario', '@${auth.username ?? ''}'),
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
