import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../config/colors.dart';
import 'chat_screen.dart';
import 'create_group_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> with SingleTickerProviderStateMixin {
  List<User> _users = [];
  bool _loading = true;
  bool _showSearch = false;
  bool _fabOpen = false;
  final _searchCtrl = TextEditingController();
  late AnimationController _animCtrl;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _rotation = Tween<double>(begin: 0.0, end: 0.125).animate(_animCtrl);
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    try {
      final r = await ApiService.getUsers();
      if (r is List) setState(() { _users = r.map((u) => User.fromJson(u)).toList(); _loading = false; });
    } catch (_) { setState(() => _loading = false); }
  }

  void _toggleFab() {
    setState(() { _fabOpen = !_fabOpen; _fabOpen ? _animCtrl.forward() : _animCtrl.reverse(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: _showSearch ? TextField(controller: _searchCtrl, autofocus: true, style: const TextStyle(color: Colors.white, fontSize: 16), decoration: const InputDecoration(hintText: 'Buscar...', hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none), onChanged: (_) => setState(() {})) : const Text('Contactos', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(icon: Icon(_showSearch ? Icons.close : Icons.search, color: Colors.white), onPressed: () => setState(() { _showSearch = !_showSearch; _searchCtrl.clear(); })),
          IconButton(icon: const Icon(Icons.qr_code_scanner, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _loadUsers),
        ],
      ),
      body: _loading ? const Center(child: CircularProgressIndicator(color: SeendColors.primary)) : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (_, i) {
          final u = _users[i];
          return ListTile(
            leading: CircleAvatar(radius: 24, backgroundColor: Colors.grey[300], child: Text(u.initial, style: const TextStyle(color: Colors.white))),
            title: Text(u.displayName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            subtitle: Text(u.info ?? '', style: const TextStyle(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(userId: u.id, userName: u.displayName, userPhoto: u.photoUrl, userPhone: u.phoneNumber))),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_fabOpen) ...[
            FloatingActionButton.extended(
              heroTag: 'group',
              backgroundColor: SeendColors.primary,
              icon: const Icon(Icons.groups, color: Colors.white),
              label: const Text('Nuevo grupo', style: TextStyle(color: Colors.white, fontSize: 13)),
              onPressed: () { _toggleFab(); Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateGroupScreen())); },
            ),
            const SizedBox(height: 12),
          ],
          FloatingActionButton(
            heroTag: 'main',
            backgroundColor: SeendColors.primary,
            child: AnimatedBuilder(animation: _rotation, builder: (_, child) => Transform.rotate(angle: _rotation.value * 2 * 3.14159, child: Icon(_fabOpen ? Icons.close : Icons.add, color: Colors.white))),
            onPressed: _toggleFab,
          ),
        ],
      ),
    );
  }
}
