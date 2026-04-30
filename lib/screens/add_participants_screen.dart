import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../config/colors.dart';

class AddParticipantsScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  const AddParticipantsScreen({super.key, required this.groupId, required this.groupName});
  @override
  State<AddParticipantsScreen> createState() => _AddParticipantsScreenState();
}

class _AddParticipantsScreenState extends State<AddParticipantsScreen> {
  String get _link => 'https://chat.seend.com/group/${widget.groupId}';

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: _link));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enlace copiado'), backgroundColor: SeendColors.primary, duration: Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Añadir participantes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border.all(color: SeendColors.border), borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [Icon(Icons.link, color: SeendColors.primary, size: 18), SizedBox(width: 8), Text('Enlace de invitación', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))]),
              const SizedBox(height: 8),
              Text(_link, style: const TextStyle(fontSize: 13, color: SeendColors.textSecondary)),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: OutlinedButton(onPressed: _copyLink, child: const Text('Copiar enlace'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: () => Share.share(_link, subject: 'Únete a mi grupo en Seend'), child: const Text('Compartir'))),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}
