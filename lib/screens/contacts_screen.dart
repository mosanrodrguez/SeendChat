import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../config/colors.dart';
import 'chat_screen.dart';
import 'create_group_screen.dart';
import 'create_channel_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<User> _users = [];
  bool _loading = true;
  bool _showSearch = false;
  final _searchCtrl = TextEditingController();

  @override
  void initState() { super.initState(); _loadUsers(); }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    try {
      final r = await ApiService.getUsers();
      if (r is List) setState(() { _users = r.map((u) => User.fromJson(u)).toList(); _loading = false; });
    } catch (_) { setState(() => _loading = false); }
  }

  List<User> _filterUsers() {
    if (_searchCtrl.text.isEmpty) return _users;
    return _users.where((u) => (u.fullName ?? '').toLowerCase().contains(_searchCtrl.text.toLowerCase()) || (u.username ?? '').toLowerCase().contains(_searchCtrl.text.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filterUsers();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: _showSearch
            ? TextField(controller: _searchCtrl, autofocus: true, style: const TextStyle(color: Colors.white, fontSize: 16), decoration: const InputDecoration(hintText: 'Buscar...', hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none), onChanged: (_) => setState(() {}))
            : const Text('Contactos', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(icon: Icon(_showSearch ? Icons.close : Icons.search, color: Colors.white), onPressed: () => setState(() { _showSearch = !_showSearch; _searchCtrl.clear(); })),
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _loadUsers),
        ],
      ),
      body: Column(children: [
        ListTile(leading: const Icon(Icons.group_add, color: SeendColors.primary), title: const Text('Nuevo grupo'), trailing: const Icon(Icons.chevron_right, color: SeendColors.textSecondary), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateGroupScreen()))),
        ListTile(leading: const Icon(Icons.campaign, color: SeendColors.primary), title: const Text('Nuevo canal'), trailing: const Icon(Icons.chevron_right, color: SeendColors.textSecondary), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateChannelScreen()))),
        const Divider(height: 1),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: SeendColors.primary))
              : filtered.isEmpty
                  ? Center(child: Text('No se encontraron contactos', style: TextStyle(fontSize: 14, color: SeendColors.textSecondary)))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final u = filtered[i];
                        return ListTile(
                          leading: CircleAvatar(radius: 24, backgroundColor: Colors.grey[300], child: Text(u.initial, style: const TextStyle(color: Colors.white))),
                          title: Text(u.displayName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          subtitle: Text(u.info ?? '', style: const TextStyle(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(userId: u.id, userName: u.displayName, userPhoto: u.photoUrl, userPhone: u.phoneNumber))),
                        );
                      },
                    ),
        ),
      ]),
    );
  }
}
