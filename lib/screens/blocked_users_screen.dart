import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/colors.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});
  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  List<dynamic> _blocked = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final data = await ApiService.getBlocked();
      if (data is List) setState(() { _blocked = data; _loading = false; });
    } catch (_) { setState(() => _loading = false); }
  }

  Future<void> _unblock(String userId) async {
    await ApiService.unblockUser(userId);
    setState(() => _blocked.removeWhere((b) => b['blockedUserId'] == userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Usuarios bloqueados', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: _loading ? const Center(child: CircularProgressIndicator(color: SeendColors.primary)) : _blocked.isEmpty ? Center(child: Text('No hay usuarios bloqueados', style: TextStyle(fontSize: 14, color: SeendColors.textSecondary))) : ListView.builder(
        itemCount: _blocked.length,
        itemBuilder: (_, i) {
          final user = _blocked[i];
          return ListTile(
            leading: CircleAvatar(radius: 24, backgroundColor: Colors.grey[300], child: Text((user['fullName'] ?? '?')[0].toUpperCase(), style: const TextStyle(color: Colors.white))),
            title: Text(user['fullName'] ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            subtitle: Text('Bloqueado el ${user['blockedAt'] ?? ''}', style: const TextStyle(fontSize: 12, color: SeendColors.textSecondary)),
            trailing: TextButton(onPressed: () => _unblock(user['blockedUserId']), child: const Text('Desbloquear', style: TextStyle(color: SeendColors.primary, fontSize: 13, fontWeight: FontWeight.w600))),
          );
        },
      ),
    );
  }
}
