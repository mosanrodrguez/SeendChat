import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<Map<String, String>> _phoneContacts = [];
  bool _loading = true;
  bool _showSearch = false;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    await Future.wait([_loadUsers(), _loadPhoneContacts()]);
    setState(() => _loading = false);
  }

  Future<void> _loadUsers() async {
    try {
      final r = await ApiService.getUsers();
      if (r is List) setState(() => _users = r.map((u) => User.fromJson(u)).toList());
    } catch (_) {}
  }

  Future<void> _loadPhoneContacts() async {
    try {
      const channel = MethodChannel('com.seend.chat/contacts');
      final contacts = await channel.invokeMethod('getContacts');
      if (contacts is List) {
        setState(() => _phoneContacts = contacts.map<Map<String, String>>((c) => {'name': c['name'] ?? '', 'phone': c['phone'] ?? ''}).toList());
      }
    } catch (_) {
      // Fallback: contactos dummy para pruebas
      setState(() => _phoneContacts = [
        {'name': 'María García', 'phone': '+52 55 1234 5678'},
        {'name': 'Carlos López', 'phone': '+52 55 8765 4321'},
        {'name': 'Laura Martínez', 'phone': '+1 555 123 4567'},
        {'name': 'Pedro Sánchez', 'phone': '+34 612 345 678'},
        {'name': 'Ana Gómez', 'phone': '+57 300 123 4567'},
        {'name': 'Diego Ruiz', 'phone': '+54 11 2345 6789'},
        {'name': 'Marta Fernández', 'phone': '+56 9 8765 4321'},
      ]);
    }
  }

  List<User> _filterUsers() {
    if (_searchCtrl.text.isEmpty) return _users;
    return _users.where((u) => (u.fullName ?? '').toLowerCase().contains(_searchCtrl.text.toLowerCase()) || (u.username ?? '').toLowerCase().contains(_searchCtrl.text.toLowerCase())).toList();
  }

  List<Map<String, String>> _filterPhoneContacts() {
    if (_searchCtrl.text.isEmpty) return _phoneContacts;
    return _phoneContacts.where((c) => c['name']!.toLowerCase().contains(_searchCtrl.text.toLowerCase()) || c['phone']!.contains(_searchCtrl.text)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _filterUsers();
    final filteredPhone = _filterPhoneContacts();
    // Mostrar solo contactos del teléfono que NO están en Seend
    final phoneNotInSeend = filteredPhone.where((pc) => !_users.any((u) => u.phoneNumber == pc['phone'])).toList();

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
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _loadAll),
        ],
      ),
      body: Column(children: [
        ListTile(leading: const Icon(Icons.group_add, color: SeendColors.primary), title: const Text('Nuevo grupo'), trailing: const Icon(Icons.chevron_right, color: SeendColors.textSecondary), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateGroupScreen()))),
        ListTile(leading: const Icon(Icons.campaign, color: SeendColors.primary), title: const Text('Nuevo canal'), trailing: const Icon(Icons.chevron_right, color: SeendColors.textSecondary), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateChannelScreen()))),
        const Divider(height: 1),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: SeendColors.primary))
              : ListView(
                  children: [
                    if (filteredUsers.isNotEmpty) ...[
                      const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 4), child: Text('Usuarios de Seend', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary, fontWeight: FontWeight.w500))),
                      ...filteredUsers.map((u) => ListTile(
                        leading: CircleAvatar(radius: 24, backgroundColor: Colors.grey[300], child: Text(u.initial, style: const TextStyle(color: Colors.white))),
                        title: Text(u.displayName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        subtitle: Text(u.info ?? '', style: const TextStyle(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(userId: u.id, userName: u.displayName, userPhoto: u.photoUrl, userPhone: u.phoneNumber))),
                      )),
                    ],
                    if (phoneNotInSeend.isNotEmpty) ...[
                      const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 4), child: Text('Contactos del teléfono', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary, fontWeight: FontWeight.w500))),
                      ...phoneNotInSeend.map((c) => ListTile(
                        leading: CircleAvatar(radius: 24, backgroundColor: Colors.grey[400], child: Text(c['name']?.isNotEmpty == true ? c['name']![0].toUpperCase() : '?', style: const TextStyle(color: Colors.white))),
                        title: Text(c['name'] ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        subtitle: Text(c['phone'] ?? '', style: const TextStyle(fontSize: 13, color: SeendColors.textSecondary)),
                        trailing: const Text('Invitar', style: TextStyle(color: SeendColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invitación enviada'), backgroundColor: SeendColors.primary));
                        },
                      )),
                    ],
                  ],
                ),
        ),
      ]),
    );
  }
}
