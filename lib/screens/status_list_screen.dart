import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/status_provider.dart';
import '../config/colors.dart';
import 'status_viewer_screen.dart';

class StatusListScreen extends StatelessWidget {
  const StatusListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statusProvider = context.watch<StatusProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        children: [
          // Mi estado
          const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 4), child: Text('MIS ESTADOS', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary, fontWeight: FontWeight.w500))),
          ListTile(
            leading: CircleAvatar(radius: 24, backgroundColor: SeendColors.primary, child: const Icon(Icons.add, color: Colors.white)),
            title: const Text('Mi estado', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            subtitle: const Text('Añadir estado', style: TextStyle(fontSize: 13)),
            onTap: () {},
          ),
          const Divider(height: 1),
          // Recientes
          if (statusProvider.recentStatuses.isNotEmpty) ...[
            const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 4), child: Text('RECIENTES', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary, fontWeight: FontWeight.w500))),
            ...statusProvider.recentStatuses.map((s) => ListTile(
              leading: CircleAvatar(radius: 24, backgroundColor: Colors.grey[300], child: Text(s.userName.isNotEmpty ? s.userName[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white))),
              title: Text(s.userName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              subtitle: Text(s.timeAgo, style: const TextStyle(fontSize: 13)),
              trailing: const Icon(Icons.chevron_right, color: SeendColors.textSecondary),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StatusViewerScreen(status: s))),
            )),
            const Divider(height: 1),
          ],
          // Vistos
          if (statusProvider.viewedStatuses.isNotEmpty) ...[
            const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 4), child: Text('VISTOS', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary, fontWeight: FontWeight.w500))),
            ...statusProvider.viewedStatuses.map((s) => ListTile(
              leading: CircleAvatar(radius: 24, backgroundColor: Colors.grey[300], child: Text(s.userName.isNotEmpty ? s.userName[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white))),
              title: Text(s.userName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              subtitle: Text(s.timeAgo, style: const TextStyle(fontSize: 13)),
              trailing: const Icon(Icons.chevron_right, color: SeendColors.textSecondary),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StatusViewerScreen(status: s))),
            )),
          ],
        ],
      ),
    );
  }
}
