import 'package:flutter/material.dart';
import '../config/colors.dart';

class CreateChannelScreen extends StatefulWidget {
  const CreateChannelScreen({super.key});
  @override
  State<CreateChannelScreen> createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Crear canal', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
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
                CircleAvatar(radius: 40, backgroundColor: SeendColors.primary, child: const Icon(Icons.campaign, color: Colors.white, size: 36)),
                Positioned(bottom: 0, right: 0, child: Container(width: 28, height: 28, decoration: BoxDecoration(color: SeendColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.camera_alt, color: Colors.white, size: 14))),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Center(child: Text('Toca para añadir foto', style: TextStyle(fontSize: 11, color: SeendColors.textSecondary))),
          const SizedBox(height: 24),
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nombre del canal')),
          const SizedBox(height: 16),
          TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Descripción (opcional)'), maxLines: 2),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: SeendColors.border), borderRadius: BorderRadius.circular(4)),
            child: Row(children: [
              const Icon(Icons.lock, size: 16, color: SeendColors.textSecondary),
              const SizedBox(width: 8),
              const Expanded(child: Text('Solo los administradores pueden enviar mensajes', style: TextStyle(fontSize: 13, color: SeendColors.textSecondary))),
            ]),
          ),
        ],
      ),
    );
  }
}
