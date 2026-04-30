import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/colors.dart';
import '../config/api_config.dart';

class ChannelInfoScreen extends StatefulWidget {
  final String channelId;
  final String channelName;
  const ChannelInfoScreen({super.key, required this.channelId, required this.channelName});
  @override
  State<ChannelInfoScreen> createState() => _ChannelInfoScreenState();
}

class _ChannelInfoScreenState extends State<ChannelInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final link = ApiConfig.channelUrl(widget.channelId);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Información del canal', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Center(child: CircleAvatar(radius: 40, backgroundColor: SeendColors.primary, child: const Icon(Icons.campaign, color: Colors.white, size: 36))),
        const SizedBox(height: 12),
        Center(child: Text(widget.channelName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        Center(child: const Text('Canal · 2.450 suscriptores', style: TextStyle(fontSize: 13, color: SeendColors.textSecondary))),
        const SizedBox(height: 24),
        const Divider(),
        ListTile(leading: const Icon(Icons.link, color: SeendColors.primary), title: const Text('Enlace del canal'), trailing: const Icon(Icons.chevron_right), onTap: () { Clipboard.setData(ClipboardData(text: link)); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enlace copiado'), backgroundColor: SeendColors.primary)); }),
        ListTile(leading: const Icon(Icons.block, color: SeendColors.error), title: const Text('Usuarios baneados'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        const Divider(),
        SizedBox(width: double.infinity, height: 48, child: OutlinedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, style: OutlinedButton.styleFrom(foregroundColor: SeendColors.error, side: const BorderSide(color: SeendColors.error)), child: const Text('SALIR DEL CANAL', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
      ]),
    );
  }
}
