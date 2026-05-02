import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../config/colors.dart';
import '../config/api_config.dart';
import '../services/api_service.dart';
import 'member_options_screen.dart';

class GroupInfoScreen extends StatefulWidget {
  final String groupId; final String groupName;
  const GroupInfoScreen({super.key, required this.groupId, required this.groupName});
  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  Map<String, dynamic>? _group;
  List<dynamic> _members = [];
  Map<String, dynamic>? _permissions;
  List<dynamic> _banned = [];
  bool _loading = true;
  bool _isOwner = false;
  bool _isAdmin = false;

  @override
  void initState() { super.initState(); _loadGroup(); }

  Future<void> _loadGroup() async {
    try {
      final response = await ApiService.get('groups/${widget.groupId}');
      if (response != null) {
        setState(() {
          _group = response['group'];
          _members = response['members'] ?? [];
          _permissions = response['permissions'];
          _banned = response['banned'] ?? [];
          _loading = false;
          // TODO: verificar rol del usuario actual
          _isOwner = _members.any((m) => m['userId'] == 'current_user_id' && m['role'] == 'owner');
          _isAdmin = _members.any((m) => m['userId'] == 'current_user_id' && m['role'] == 'admin');
        });
      }
    } catch (_) { setState(() => _loading = false); }
  }

  Future<void> _leaveGroup() async {
    try {
      await ApiService.delete('groups/${widget.groupId}/members/current_user_id');
      if (mounted) { Navigator.pop(context); Navigator.pop(context); }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: SeendColors.error));
    }
  }

  Future<void> _deleteGroup() async {
    try {
      await ApiService.delete('groups/${widget.groupId}');
      if (mounted) { Navigator.pop(context); Navigator.pop(context); }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: SeendColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(appBar: AppBar(title: const Text('Información del grupo', style: TextStyle(color: Colors.white))), body: const Center(child: CircularProgressIndicator(color: SeendColors.primary)));

    final memberCount = _members.length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Información del grupo', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Center(child: CircleAvatar(radius: 40, backgroundColor: SeendColors.primary, child: const Icon(Icons.groups, color: Colors.white, size: 36))),
        const SizedBox(height: 12),
        Center(child: Text(_group?['name'] ?? widget.groupName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        Center(child: Text('Grupo · $memberCount miembros', style: const TextStyle(fontSize: 13, color: SeendColors.textSecondary))),
        const SizedBox(height: 24),
        const Divider(),
        if (_group?['description'] != null) ...[
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)), child: Text(_group!['description'] ?? '', style: const TextStyle(fontSize: 14))),
          const SizedBox(height: 16),
        ],
        if (_isOwner || _isAdmin) ...[
          ListTile(leading: const Icon(Icons.settings, color: SeendColors.primary), title: const Text('Ajustes del grupo'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
          ListTile(leading: const Icon(Icons.link, color: SeendColors.primary), title: const Text('Enlace de invitación'), trailing: const Icon(Icons.chevron_right), onTap: () { Share.share('Únete a mi grupo en Seend: ${ApiConfig.groupUrl(widget.groupId)}'); }),
          ListTile(leading: const Icon(Icons.block, color: SeendColors.primary), title: const Text('Usuarios baneados'), trailing: Text('${_banned.length}', style: const TextStyle(color: SeendColors.textSecondary)), onTap: () {}),
          ListTile(leading: const Icon(Icons.delete_sweep, color: SeendColors.primary), title: const Text('Vaciar chat'), onTap: () {}),
        ],
        ListTile(leading: const Icon(Icons.photo_library, color: SeendColors.primary), title: const Text('Multimedia compartida'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        ListTile(leading: const Icon(Icons.delete_outline, color: SeendColors.textSecondary), title: const Text('Borrar historial'), onTap: () {}),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, height: 48, child: OutlinedButton(onPressed: _leaveGroup, style: OutlinedButton.styleFrom(foregroundColor: SeendColors.error, side: const BorderSide(color: SeendColors.error)), child: const Text('SALIR DEL GRUPO', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
        if (_isOwner) ...[const SizedBox(height: 12), SizedBox(width: double.infinity, height: 48, child: OutlinedButton(onPressed: _deleteGroup, style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)), child: const Text('ELIMINAR GRUPO', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))))],
        const SizedBox(height: 24),
        Text('Miembros $memberCount', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ..._members.map((m) => ListTile(
          leading: CircleAvatar(radius: 20, backgroundColor: Colors.grey[300], child: Text((m['fullName'] ?? '?')[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 14))),
          title: Text(m['fullName'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          subtitle: Text(m['info'] ?? '', style: const TextStyle(fontSize: 12, color: SeendColors.textSecondary), maxLines: 1),
          trailing: Text(m['role'] == 'owner' ? 'Propietario' : m['role'] == 'admin' ? 'Administrador' : 'Miembro', style: TextStyle(fontSize: 12, color: m['role'] == 'owner' ? SeendColors.primary : SeendColors.textSecondary)),
          onLongPress: (_isOwner || _isAdmin) ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => MemberOptionsScreen(member: m))) : null,
        )),
      ]),
    );
  }
}
