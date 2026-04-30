import 'package:flutter/material.dart';
import '../config/colors.dart';

class GroupInfoScreen extends StatelessWidget {
  final String groupId;
  final String groupName;
  const GroupInfoScreen({super.key, required this.groupId, required this.groupName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Información del grupo', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Center(child: CircleAvatar(radius: 40, backgroundColor: SeendColors.primary, child: const Icon(Icons.group, color: Colors.white, size: 36))),
        const SizedBox(height: 12),
        Center(child: Text(groupName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        Center(child: const Text('Grupo · 5 participantes', style: TextStyle(fontSize: 13, color: SeendColors.textSecondary))),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 12),
        const Text('Descripción', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary)),
        const SizedBox(height: 4),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)), child: const Text('Grupo para coordinar las salidas de los fines de semana.', style: TextStyle(fontSize: 14))),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 48, child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: SeendColors.error, side: const BorderSide(color: SeendColors.error)), child: const Text('SALIR DEL GRUPO', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
      ]),
    );
  }
}
