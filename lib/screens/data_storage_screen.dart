import 'package:flutter/material.dart';
import '../config/colors.dart';

class DataStorageScreen extends StatefulWidget {
  const DataStorageScreen({super.key});
  @override
  State<DataStorageScreen> createState() => _DataStorageScreenState();
}

class _DataStorageScreenState extends State<DataStorageScreen> {
  bool _autoDownloadWifi = true;
  bool _autoDownloadMobile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Datos y almacenamiento', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border.all(color: SeendColors.border), borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            const Text('Espacio usado', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            FutureBuilder<int>(future: _getCacheSize(), builder: (_, snapshot) => Text('${(snapshot.data ?? 0) / 1024 / 1024} MB', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: SeendColors.primary))),
            const Text('de multimedia almacenada', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary)),
          ]),
        ),
        const SizedBox(height: 24),
        const Text('Descarga automática', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        SwitchListTile(title: const Text('Con WiFi', style: TextStyle(fontSize: 14)), value: _autoDownloadWifi, onChanged: (v) => setState(() => _autoDownloadWifi = v), activeColor: SeendColors.primary),
        SwitchListTile(title: const Text('Con datos móviles', style: TextStyle(fontSize: 14)), value: _autoDownloadMobile, onChanged: (v) => setState(() => _autoDownloadMobile = v), activeColor: SeendColors.primary),
      ]),
    );
  }

  Future<int> _getCacheSize() async {
    try { return await DefaultCacheManager().getTotalSize(); } catch (_) { return 0; }
  }
}
