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
  bool _saveToInternal = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Datos y almacenamiento', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border.all(color: SeendColors.border), borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              const Text('Espacio usado', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Text('45.2 MB', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: SeendColors.primary)),
              const Text('de multimedia almacenada', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary)),
            ]),
          ),
          const SizedBox(height: 24),
          const Text('Descarga automática', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SwitchListTile(title: const Text('Con WiFi'), value: _autoDownloadWifi, onChanged: (v) => setState(() => _autoDownloadWifi = v), activeColor: SeendColors.primary),
          SwitchListTile(title: const Text('Con datos móviles'), value: _autoDownloadMobile, onChanged: (v) => setState(() => _autoDownloadMobile = v), activeColor: SeendColors.primary),
          const SizedBox(height: 24),
          const Text('Almacenamiento', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SwitchListTile(title: const Text('Guardar en almacenamiento interno'), subtitle: const Text('La multimedia se guarda dentro de la app'), value: _saveToInternal, onChanged: (v) => setState(() => _saveToInternal = v), activeColor: SeendColors.primary),
        ],
      ),
    );
  }
}
