import 'package:flutter/material.dart';
import '../config/colors.dart';

class SelectMembersScreen extends StatefulWidget {
  const SelectMembersScreen({super.key});
  @override
  State<SelectMembersScreen> createState() => _SelectMembersScreenState();
}

class _SelectMembersScreenState extends State<SelectMembersScreen> {
  final List<Map<String, String>> _allUsers = [
    {'id': '1', 'name': 'María García', 'phone': '+52 55 1234 5678'},
    {'id': '2', 'name': 'Carlos López', 'phone': '+52 55 8765 4321'},
    {'id': '3', 'name': 'Laura Martínez', 'phone': '+1 555 123 4567'},
    {'id': '4', 'name': 'Pedro Sánchez', 'phone': '+34 612 345 678'},
    {'id': '5', 'name': 'Ana Gómez', 'phone': '+57 300 123 4567'},
  ];
  final List<Map<String, String>> _selected = [];
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _search.isEmpty ? _allUsers : _allUsers.where((u) => u['name']!.toLowerCase().contains(_search.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Añadir miembros', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [IconButton(icon: const Icon(Icons.check, color: Colors.white), onPressed: () => Navigator.pop(context, _selected))],
      ),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: TextField(onChanged: (v) => setState(() => _search = v), decoration: const InputDecoration(hintText: 'Buscar...', prefixIcon: Icon(Icons.search)),
        )),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final user = filtered[i];
              final isSelected = _selected.any((s) => s['id'] == user['id']);
              return CheckboxListTile(
                value: isSelected,
                onChanged: (v) {
                  setState(() {
                    if (v == true) { _selected.add(user); } else { _selected.removeWhere((s) => s['id'] == user['id']); }
                  });
                },
                title: Text(user['name']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                subtitle: Text(user['phone']!, style: const TextStyle(fontSize: 12, color: SeendColors.textSecondary)),
                activeColor: SeendColors.primary,
              );
            },
          ),
        ),
      ]),
    );
  }
}
