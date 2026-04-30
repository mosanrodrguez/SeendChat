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
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await ApiService.getUsers();
      if (r is List) setState(() { _users = r.map((u) => User.fromJson(u)).toList(); _loading = false; });
    } catch (_) { setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                controller: _searchCtrl,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(hintText: 'Buscar...', hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none),
                onChanged: (_) => setState(() {}),
              )
            : const Text('Contactos', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(icon: Icon(_showSearch ? Icons.close : Icons.search, color: Colors.white), onPressed: () => setState(() { _showSearch = !_showSearch; _searchCtrl.clear(); })),
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _load),
        ],
      ),
      body: Column(
        children: [
          // Opciones fijas
          ListTile(leading: const Icon(Icons.group_add, color: SeendColors.primary), title: const Text('Nuevo grupo', style: TextStyle(fontSize: 15)), trailing: const Icon(Icons.chevron_right, color: SeendColors.textSecondary), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateGroupScreen()))),
          ListTile(leading: const Icon(Icons.campaign, color: SeendColors.primary), title: const Text('Nuevo canal', style: TextStyle(fontSize: 15)), trailing: const Icon(Icons.chevron_right, color: SeendColors.textSecondary), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateChannelScreen()))),
          const Divider(height: 1),
          // Lista de contactos
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: SeendColors.primary))
                : ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (_, i) {
                      final u = _users[i];
                      return ListTile(
                        leading: CircleAvatar(radius: 24, backgroundColor: Colors.grey[300], child: Text(u.initial, style: const TextStyle(color: Colors.white))),
                        title: Text(u.displayName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        subtitle: Text(u.info ?? '', style: const TextStyle(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(userId: u.id, userName: u.displayName, userPhoto: u.photoUrl))),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
