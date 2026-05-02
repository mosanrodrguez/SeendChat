import 'package:flutter/material.dart';
import '../config/colors.dart';

class MemberOptionsScreen extends StatelessWidget {
  final Map<String, dynamic> member;
  const MemberOptionsScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final isAdmin = member['role'] == 'admin';
    final isOwner = member['role'] == 'owner';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text(member['fullName'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Center(child: CircleAvatar(radius: 48, backgroundColor: Colors.grey[300], child: Text((member['fullName'] ?? '?')[0].toUpperCase(), style: const TextStyle(fontSize: 32, color: Colors.white)))),
        const SizedBox(height: 16),
        Center(child: Text(member['fullName'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        Center(child: Text(member['role'] == 'owner' ? 'Propietario' : member['role'] == 'admin' ? 'Administrador' : 'Miembro', style: TextStyle(fontSize: 14, color: member['role'] == 'owner' ? SeendColors.primary : SeendColors.textSecondary))),
        const SizedBox(height: 32),
        if (!isOwner) ...[
          ListTile(leading: Icon(isAdmin ? Icons.admin_panel_settings : Icons.admin_panel_settings, color: SeendColors.primary), title: Text(isAdmin ? 'Quitar administrador' : 'Hacer administrador'), onTap: () { Navigator.pop(context); }),
          ListTile(leading: const Icon(Icons.remove_circle, color: SeendColors.error), title: const Text('Expulsar del grupo'), onTap: () { Navigator.pop(context); }),
          ListTile(leading: const Icon(Icons.block, color: Colors.red), title: const Text('Banear del grupo'), onTap: () { Navigator.pop(context); }),
        ],
      ]),
    );
  }
}
