import 'package:flutter/material.dart';
import '../config/colors.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});
  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _isPrivate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Crear grupo', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Crear', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(radius: 40, backgroundColor: SeendColors.primary, child: const Icon(Icons.group, color: Colors.white, size: 36)),
                Positioned(bottom: 0, right: 0, child: Container(width: 28, height: 28, decoration: BoxDecoration(color: SeendColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.camera_alt, color: Colors.white, size: 14))),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Center(child: Text('Toca para añadir foto', style: TextStyle(fontSize: 11, color: SeendColors.textSecondary))),
          const SizedBox(height: 24),
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nombre del grupo')),
          const SizedBox(height: 16),
          TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Descripción (opcional)'), maxLines: 2),
          const SizedBox(height: 24),
          const Text('Privacidad', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () => setState(() => _isPrivate = false), style: OutlinedButton.styleFrom(backgroundColor: _isPrivate ? null : SeendColors.primary, foregroundColor: _isPrivate ? SeendColors.primary : Colors.white), child: const Text('Público'))),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton(onPressed: () => setState(() => _isPrivate = true), style: OutlinedButton.styleFrom(backgroundColor: _isPrivate ? SeendColors.primary : null, foregroundColor: _isPrivate ? Colors.white : SeendColors.primary), child: const Text('Privado'))),
          ]),
        ],
      ),
    );
  }
}
