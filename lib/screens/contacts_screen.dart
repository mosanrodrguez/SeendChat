import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../config/colors.dart';
import 'chat_screen.dart';
import 'bot_chat_screen.dart';
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
  List<Map<String, String>> _bots = [];
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
    await Future.wait([_loadUsers(), _loadPhoneContacts(), _loadBots()]);
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
      setState(() => _phoneContacts = [
        {'name': 'María García', 'phone': '+52 55 1234 5678'},
        {'name': 'Carlos López', 'phone': '+52 55 8765 4321'},
        {'name': 'Laura Martínez', 'phone': '+1 555 123 4567'},
      ]);
    }
  }

  Future<void> _loadBots() async {
    try {
      final r = await ApiService.get('bots');
      if (r is List) {
        setState(() => _bots = r.map<Map<String, String>>((b) => {
          'id': b['id'] ?? '',
          'name': b['name'] ?? '',
          'username': b['username'] ?? '',
          'description': b['description'] ?? '',
        }).toList());
      }
    } catch (_) {
      // Bots de ejemplo para pruebas
      setState(() => _bots = [
        {'id': 'bot1', 'name': 'SeendBotFather', 'username': 'BotFather', 'description': 'Crea y gestiona tus bots'},
        {'id': 'bot2', 'name': 'ClimaBot', 'username': 'ClimaBot', 'description': 'Información del clima'},
        {'id': 'bot3', 'name': 'TraductorBot', 'username': 'TraductorBot', 'description': 'Traduce entre 50 idiomas'},
      ]);
    }
  }

  List<User> _filterUsers() {
    if (_searchCtrl.text.isEmpty) return _users;
    return _users.where((u) =>
      (u.fullName ?? '').toLowerCase().contains(_searchCtrl.text.toLowerCase()) ||
      (u.username ?? '').toLowerCase().contains(_searchCtrl.text.toLowerCase())
    ).toList();
  }

  List<Map<String, String>> _filterBots() {
    if (_searchCtrl.text.isEmpty) return _bots;
    return _bots.where((b) =>
      b['name']!.toLowerCase().contains(_searchCtrl.text.toLowerCase()) ||
      b['username']!.toLowerCase().contains(_searchCtrl.text.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _filterUsers();
    final filteredBots = _filterBots();

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
        // Opciones fijas
        ListTile(
          leading: const Icon(Icons.group_add, color: SeendColors.primary),
          title: const Text('Nuevo grupo', style: TextStyle(fontSize: 15)),
          trailing: const Icon(Icons.chevron_right, color: SeendColors.textSecondary),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateGroupScreen())),
        ),
        ListTile(
          leading: const Icon(Icons.campaign, color: SeendColors.primary),
          title: const Text('Nuevo canal', style: TextStyle(fontSize: 15)),
          trailing: const Icon(Icons.chevron_right, color: SeendColors.textSecondary),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateChannelScreen())),
        ),
        // SeendBotFather siempre visible
        ListTile(
          leading: CircleAvatar(radius: 20, backgroundColor: SeendColors.primary, child: const Text('🤖', style: TextStyle(fontSize: 18))),
          title: const Text('SeendBotFather', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          subtitle: const Text('Crea y gestiona tus bots', style: TextStyle(fontSize: 13)),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: SeendColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: const Text('Oficial', style: TextStyle(fontSize: 10, color: SeendColors.primary, fontWeight: FontWeight.w600)),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BotChatScreen(botId: 'botfather', botName: 'SeendBotFather', botUsername: 'BotFather'))),
        ),
        const Divider(height: 1),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: SeendColors.primary))
              : ListView(
                  children: [
                    // Bots encontrados
                    if (filteredBots.isNotEmpty) ...[
                      const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 4), child: Text('Bots', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary, fontWeight: FontWeight.w500))),
                      ...filteredBots.where((b) => b['username'] != 'BotFather').map((b) => ListTile(
                        leading: CircleAvatar(radius: 24, backgroundColor: SeendColors.primary, child: Text(b['name']?.isNotEmpty == true ? b['name']![0].toUpperCase() : '🤖', style: const TextStyle(color: Colors.white, fontSize: 16))),
                        title: Text(b['name'] ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        subtitle: Text('@${b['username'] ?? ''} · ${b['description'] ?? ''}', style: const TextStyle(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: SeendColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: const Text('Bot', style: TextStyle(fontSize: 10, color: SeendColors.primary, fontWeight: FontWeight.w600)),
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BotChatScreen(botId: b['id']!, botName: b['name']!, botUsername: b['username']!, botAvatar: null))),
                      )),
                    ],
                    // Usuarios de Seend
                    if (filteredUsers.isNotEmpty) ...[
                      const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 4), child: Text('Usuarios de Seend', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary, fontWeight: FontWeight.w500))),
                      ...filteredUsers.map((u) => ListTile(
                        leading: CircleAvatar(radius: 24, backgroundColor: Colors.grey[300], child: Text(u.initial, style: const TextStyle(color: Colors.white))),
                        title: Text(u.displayName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        subtitle: Text(u.info ?? '', style: const TextStyle(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(userId: u.id, userName: u.displayName, userPhoto: u.photoUrl, userPhone: u.phoneNumber))),
                      )),
                    ],
                  ],
                ),
        ),
      ]),
    );
  }
}
