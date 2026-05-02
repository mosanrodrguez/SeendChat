import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../config/colors.dart';

class SelectMembersScreen extends StatefulWidget {
  const SelectMembersScreen({super.key});
  @override
  State<SelectMembersScreen> createState() => _SelectMembersScreenState();
}

class _SelectMembersScreenState extends State<SelectMembersScreen> {
  List<User> _users = [];
  final List<Map<String, String>> _selected = [];
  bool _loading = true;
  String _search = '';

  @override
  void initState() { super.initState(); _loadUsers(); }

  Future<void> _loadUsers() async {
    try { final r = await ApiService.getUsers(); if (r is List) setState(() { _users = r.map((u) => User.fromJson(u)).toList(); _loading = false; }); } catch (_) { setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _search.isEmpty ? _users : _users.where((u) => (u.fullName ?? '').toLowerCase().contains(_search.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Añadir miembros', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [IconButton(icon: const Icon(Icons.check, color: Colors.white), onPressed: () => Navigator.pop(context, _selected.map((m) => {'id': m['id'], 'name': m['name']}).toList()))],
      ),
      body: _loading ? const Center(child: CircularProgressIndicator(color: SeendColors.primary)) : Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: TextField(onChanged: (v) => setState(() => _search = v), decoration: const InputDecoration(hintText: 'Buscar...', prefixIcon: Icon(Icons.search)))),
        Expanded(child: ListView.builder(itemCount: filtered.length, itemBuilder: (_, i) {
          final u = filtered[i];
          final isSelected = _selected.any((s) => s['id'] == u.id);
          return CheckboxListTile(
            value: isSelected,
            onChanged: (v) { setState(() { if (v == true) _selected.add({'id': u.id, 'name': u.displayName}); else _selected.removeWhere((s) => s['id'] == u.id); }); },
            title: Text(u.displayName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            subtitle: Text(u.info ?? '', style: const TextStyle(fontSize: 12, color: SeendColors.textSecondary)),
            secondary: CircleAvatar(radius: 20, backgroundColor: Colors.grey[300], backgroundImage: u.photoUrl != null ? NetworkImage(u.photoUrl!) : null, child: u.photoUrl == null ? Text(u.initial, style: const TextStyle(color: Colors.white)) : null),
            activeColor: SeendColors.primary,
          );
        })),
      ]),
    );
  }
}
