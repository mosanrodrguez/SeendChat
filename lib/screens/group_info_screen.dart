import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../config/colors.dart';
import '../config/api_config.dart';
import 'member_options_screen.dart';

class GroupInfoScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  const GroupInfoScreen({super.key, required this.groupId, required this.groupName});
  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  final List<Map<String, String>> _members = [
    {'id': '1', 'name': 'Tú', 'role': 'Propietario', 'photo': null},
    {'id': '2', 'name': 'María García', 'role': 'Administrador', 'photo': null},
    {'id': '3', 'name': 'Carlos López', 'role': 'Miembro', 'photo': null},
    {'id': '4', 'name': 'Laura Martínez', 'role': 'Miembro', 'photo': null},
    {'id': '5', 'name': 'Pedro Sánchez', 'role': 'Miembro', 'photo': null},
  ];

  void _showMemberOptions(Map<String, String> member) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MemberOptionsScreen(member: member)));
  }

  @override
  Widget build(BuildContext context) {
    final link = ApiConfig.groupUrl(widget.groupId);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Información del grupo', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Center(child: CircleAvatar(radius: 40, backgroundColor: SeendColors.primary, child: const Icon(Icons.group, color: Colors.white, size: 36))),
        const SizedBox(height: 12),
        Center(child: Text(widget.groupName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        Center(child: const Text('Grupo · ${5} participantes', style: TextStyle(fontSize: 13, color: SeendColors.textSecondary))),
        const SizedBox(height: 24),
        const Divider(),
        // Multimedia compartida
        ListTile(leading: const Icon(Icons.photo_library, color: SeendColors.primary), title: const Text('Multimedia compartida'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        const Divider(),
        // Link de invitación
        ListTile(leading: const Icon(Icons.link, color: SeendColors.primary), title: const Text('Enlace de invitación'), trailing: const Icon(Icons.chevron_right), onTap: () { Clipboard.setData(ClipboardData(text: link)); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enlace copiado'), backgroundColor: SeendColors.primary)); }),
        // Privacidad
        ListTile(leading: const Icon(Icons.lock, color: SeendColors.primary), title: const Text('Privacidad del grupo'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        const Divider(),
        // Miembros
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text('Miembros (${_members.length})', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
        ..._members.map((m) => ListTile(
          leading: CircleAvatar(radius: 20, backgroundColor: Colors.grey[300], child: Text(m['name']?.isNotEmpty == true ? m['name']![0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontSize: 14))),
          title: Text(m['name']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          subtitle: Text(m['role']!, style: TextStyle(fontSize: 12, color: m['role'] == 'Propietario' ? SeendColors.primary : SeendColors.textSecondary)),
          onLongPress: () => _showMemberOptions(m),
        )),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, height: 48, child: OutlinedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, style: OutlinedButton.styleFrom(foregroundColor: SeendColors.error, side: const BorderSide(color: SeendColors.error)), child: const Text('SALIR DEL GRUPO', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
      ]),
    );
  }
}
