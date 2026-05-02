import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/colors.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});
  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  Map<String, String> _settings = {};
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final data = await ApiService.getPrivacy();
      if (data != null) setState(() { _settings = Map<String, String>.from(data); _loading = false; });
    } catch (_) { setState(() => _loading = false); }
  }

  Future<void> _update(String key, String value) async {
    setState(() => _settings[key] = value);
    await ApiService.updatePrivacy({key: value});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(appBar: AppBar(title: const Text('Privacidad', style: TextStyle(color: Colors.white))), body: const Center(child: CircularProgressIndicator(color: SeendColors.primary)));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Privacidad', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        _buildOption('Foto de perfil', 'photo'),
        _buildOption('Número de teléfono', 'phone'),
        _buildOption('Info', 'info'),
        _buildOption('Nombre de usuario', 'username'),
        _buildOption('Hora de última vez', 'lastSeen'),
        _buildOption('En línea', 'online'),
        _buildOption('Quién puede agregarme a grupos', 'addToGroups'),
        _buildOption('Quién puede encontrarme', 'findByUsername'),
        const SizedBox(height: 24),
        ListTile(leading: const Icon(Icons.block, color: SeendColors.error), title: const Text('Usuarios bloqueados'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
      ]),
    );
  }

  Widget _buildOption(String title, String key) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(_settings[key] ?? 'Todos', style: const TextStyle(fontSize: 13, color: SeendColors.textSecondary)),
        const Icon(Icons.chevron_right, color: SeendColors.textSecondary),
      ]),
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => SimpleDialog(
            title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            children: ['Todos', 'Mis contactos', 'Nadie'].map((option) => RadioListTile<String>(
              title: Text(option, style: const TextStyle(fontSize: 14)),
              value: option,
              groupValue: _settings[key] ?? 'Todos',
              activeColor: SeendColors.primary,
              onChanged: (v) { _update(key, v!); Navigator.pop(ctx); },
            )).toList(),
          ),
        );
      },
    );
  }
}
