import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/api_config.dart';
import '../services/api_service.dart';
import 'chat_screen.dart';
import 'group_chat_screen.dart';

class JoinScreen extends StatefulWidget {
  final String type; // 'profile', 'group'
  final String id;
  const JoinScreen({super.key, required this.type, required this.id});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  bool _isMember = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      if (widget.type == 'profile') {
        final user = await ApiService.getUser(widget.id);
        if (user != null) setState(() { _data = user; _loading = false; });
      } else {
        final group = await ApiService.get('groups/${widget.id}');
        if (group != null) {
          final members = group['members'] ?? [];
          final currentUserId = 'current_user_id'; // TODO: obtener del provider
          setState(() {
            _data = group['group'];
            _data?['memberCount'] = members.length;
            _isMember = members.any((m) => m['userId'] == currentUserId);
            _loading = false;
          });
        }
      }
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _joinGroup() async {
    try {
      await ApiService.post('groups/${widget.id}/members', {'userId': 'current_user_id'});
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => GroupChatScreen(groupId: widget.id, groupName: _data?['name'] ?? 'Grupo')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: SeendColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: SeendColors.primary)));

    final isGroup = widget.type == 'group';
    final name = _data?['name'] ?? _data?['fullName'] ?? '';
    final description = _data?['info'] ?? _data?['description'] ?? '';
    final memberCount = _data?['memberCount'] ?? 0;
    final username = _data?['username'];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            child: Column(children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              CircleAvatar(radius: 40, backgroundColor: SeendColors.primary, child: Icon(isGroup ? Icons.groups : Icons.person, color: Colors.white, size: 36)),
              const SizedBox(height: 12),
              Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if (username != null) Text('@$username', style: const TextStyle(fontSize: 14, color: SeendColors.textSecondary)),
              if (isGroup && memberCount > 0) Text('$memberCount miembros', style: const TextStyle(fontSize: 13, color: SeendColors.textSecondary)),
              if (description.isNotEmpty) ...[const SizedBox(height: 8), Text(description, style: const TextStyle(fontSize: 13, color: SeendColors.textSecondary), textAlign: TextAlign.center)],
              const SizedBox(height: 20),
              if (isGroup && _isMember)
                const Text('Eres miembro de este grupo', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary)),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (isGroup) {
                      if (_isMember) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => GroupChatScreen(groupId: widget.id, groupName: name)));
                      } else {
                        _joinGroup();
                      }
                    } else {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatScreen(userId: widget.id, userName: name)));
                    }
                  },
                  child: Text(isGroup ? (_isMember ? 'VER GRUPO' : 'UNIRSE AL GRUPO') : 'IR AL CHAT', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
