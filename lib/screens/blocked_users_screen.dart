import 'package:flutter/material.dart';
import '../config/colors.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});
  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  final List<Map<String, String>> _blocked = [
    {'name': 'Usuario Spam', 'phone': '+1 555 000 1234', 'date': 'Bloqueado el 15/04/25'},
    {'name': 'Usuario Molesto', 'phone': '+52 55 999 8888', 'date': 'Bloqueado el 10/03/25'},
  ];

  void _unblock(int index) {
    final user = _blocked[index];
    setState(() => _blocked.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user['name']} desbloqueado'), backgroundColor: SeendColors.primary));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Usuarios bloqueados', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: _blocked.isEmpty
          ? Center(child: Text('No hay usuarios bloqueados', style: TextStyle(fontSize: 14, color: SeendColors.textSecondary)))
          : ListView.builder(
              itemCount: _blocked.length,
              itemBuilder: (_, i) {
                final user = _blocked[i];
                return ListTile(
                  leading: CircleAvatar(radius: 24, backgroundColor: Colors.grey[300], child: Text(user['name']?.isNotEmpty == true ? user['name']![0].toUpperCase() : '?', style: const TextStyle(color: Colors.white))),
                  title: Text(user['name']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  subtitle: Text(user['date']!, style: const TextStyle(fontSize: 12, color: SeendColors.textSecondary)),
                  trailing: TextButton(onPressed: () => _unblock(i), child: const Text('Desbloquear', style: TextStyle(color: SeendColors.primary, fontSize: 13, fontWeight: FontWeight.w600))),
                );
              },
            ),
    );
  }
}
