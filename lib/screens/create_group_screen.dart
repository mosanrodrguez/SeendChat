import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../config/colors.dart';
import '../services/api_service.dart';
import 'select_members_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});
  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  File? _photo;
  List<Map<String, String>> _selectedMembers = [];

  Future<void> _pickPhoto() async { final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70); if (picked != null) setState(() => _photo = File(picked.path)); }

  void _addMembers() async { final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => SelectMembersScreen())); if (result != null && mounted) setState(() => _selectedMembers = List<Map<String, String>>.from(result)); }

  Future<void> _create() async {
    if (_nameCtrl.text.trim().isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa un nombre'), backgroundColor: SeendColors.error)); return; }
    try {
      String? photoUrl;
      if (_photo != null) { final bytes = await _photo!.readAsBytes(); final response = await ApiService.uploadFile('upload', bytes, 'group_${DateTime.now().millisecondsSinceEpoch}.jpg'); if (response != null && response['url'] != null) photoUrl = response['url']; }
      final memberIds = _selectedMembers.map((m) => m['id']!).toList();
      await ApiService.createGroup({'name': _nameCtrl.text.trim(), 'description': _descCtrl.text.trim(), 'photoUrl': photoUrl, 'members': memberIds});
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grupo creado'), backgroundColor: SeendColors.primary)); Navigator.pop(context); }
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: SeendColors.error)); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Crear grupo', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)), actions: [TextButton(onPressed: _create, child: const Text('Crear', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)))]),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Center(child: GestureDetector(onTap: _pickPhoto, child: Stack(children: [CircleAvatar(radius: 48, backgroundColor: SeendColors.primary, backgroundImage: _photo != null ? FileImage(_photo!) : null, child: _photo == null ? const Icon(Icons.groups, color: Colors.white, size: 44) : null), Positioned(bottom: 0, right: 0, child: Container(width: 28, height: 28, decoration: BoxDecoration(color: SeendColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.camera_alt, color: Colors.white, size: 14))]))),
        const SizedBox(height: 24),
        TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nombre del grupo')),
        const SizedBox(height: 16),
        TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Descripción (opcional)'), maxLines: 2),
        const SizedBox(height: 24),
        ListTile(leading: const Icon(Icons.person_add, color: SeendColors.primary), title: Text('Añadir miembros (${_selectedMembers.length})', style: const TextStyle(fontSize: 15)), trailing: const Icon(Icons.chevron_right), onTap: _addMembers),
        if (_selectedMembers.isNotEmpty) Wrap(spacing: 8, children: _selectedMembers.map((m) => Chip(avatar: CircleAvatar(radius: 12, backgroundColor: Colors.grey[300], child: Text(m['name']?[0] ?? '?', style: const TextStyle(fontSize: 10))), label: Text(m['name'] ?? '', style: const TextStyle(fontSize: 12)), onDeleted: () => setState(() => _selectedMembers.remove(m)))).toList()),
      ]),
    );
  }
}
