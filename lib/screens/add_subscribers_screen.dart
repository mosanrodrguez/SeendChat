import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../config/colors.dart';

class AddSubscribersScreen extends StatefulWidget {
  final String channelId;
  final String channelName;
  const AddSubscribersScreen({super.key, required this.channelId, required this.channelName});
  @override
  State<AddSubscribersScreen> createState() => _AddSubscribersScreenState();
}

class _AddSubscribersScreenState extends State<AddSubscribersScreen> {
  String get _link => 'https://chat.seend.com/channel/${widget.channelId}';

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: _link));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enlace copiado'), backgroundColor: SeendColors.primary, duration: Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Añadir suscriptores', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border.all(color: SeendColors.border), borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [Icon(Icons.link, color: SeendColors.primary, size: 18), SizedBox(width: 8), Text('Enlace del canal', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))]),
              const SizedBox(height: 8),
              Text(_link, style: const TextStyle(fontSize: 13, color: SeendColors.textSecondary)),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: OutlinedButton(onPressed: _copyLink, child: const Text('Copiar enlace'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: () => Share.share(_link, subject: 'Suscríbete a mi canal en Seend'), child: const Text('Compartir'))),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}
