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

  void _create() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa un nombre'), backgroundColor: SeendColors.error));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Canal creado'), backgroundColor: SeendColors.primary));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Crear canal', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [TextButton(onPressed: _create, child: const Text('Crear', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)))],
      ),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Center(
          child: Stack(children: [
            CircleAvatar(radius: 48, backgroundColor: SeendColors.primary, child: const Icon(Icons.campaign, color: Colors.white, size: 44)),
            Positioned(bottom: 0, right: 0, child: Container(width: 28, height: 28, decoration: BoxDecoration(color: SeendColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.camera_alt, color: Colors.white, size: 14))),
          ]),
        ),
        const SizedBox(height: 24),
        TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nombre del canal')),
        const SizedBox(height: 16),
        TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Descripción (opcional)'), maxLines: 2),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border.all(color: SeendColors.border), borderRadius: BorderRadius.circular(8)),
          child: const Row(children: [Icon(Icons.info_outline, size: 18, color: SeendColors.textSecondary), SizedBox(width: 8), Expanded(child: Text('Los suscriptores podrán ver los mensajes pero solo los administradores pueden enviar.', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary)))]),
        ),
      ]),
    );
  }
}
