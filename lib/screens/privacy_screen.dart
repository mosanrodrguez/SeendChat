import 'package:flutter/material.dart';
import '../config/colors.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});
  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  String _profilePhoto = 'Todos';
  String _phoneNumber = 'Mis contactos';
  String _lastSeen = 'Todos';
  String _online = 'Todos';
  String _addToGroups = 'Todos';
  String _findByUsername = 'Todos';
  bool _stealthMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Privacidad', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildPrivacyOption('Foto de perfil', _profilePhoto, (v) => setState(() => _profilePhoto = v ?? 'Todos')),
          _buildPrivacyOption('Número de teléfono', _phoneNumber, (v) => setState(() => _phoneNumber = v ?? 'Mis contactos')),
          _buildPrivacyOption('Hora de última vez', _lastSeen, (v) => setState(() => _lastSeen = v ?? 'Todos')),
          _buildPrivacyOption('En línea', _online, (v) => setState(() => _online = v ?? 'Todos')),
          _buildPrivacyOption('Quién puede agregarme a grupos', _addToGroups, (v) => setState(() => _addToGroups = v ?? 'Todos')),
          _buildPrivacyOption('Quién puede encontrarme', _findByUsername, (v) => setState(() => _findByUsername = v ?? 'Todos')),
          const SizedBox(height: 16),
          SwitchListTile(title: const Text('Sigilo en grupos'), subtitle: const Text('Unirte sin que los demás sean notificados'), value: _stealthMode, onChanged: (v) => setState(() => _stealthMode = v), activeColor: SeendColors.primary),
          const SizedBox(height: 24),
          ListTile(leading: const Icon(Icons.block, color: SeendColors.error), title: const Text('Usuarios bloqueados'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildPrivacyOption(String title, String currentValue, Function(String?) onChanged) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: Text(currentValue, style: const TextStyle(fontSize: 13, color: SeendColors.textSecondary)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => SimpleDialog(
            title: Text(title),
            children: ['Todos', 'Mis contactos', 'Nadie'].map((option) => SimpleDialogOption(onPressed: () { onChanged(option); Navigator.pop(ctx); }, child: Text(option, style: TextStyle(fontWeight: currentValue == option ? FontWeight.bold : FontWeight.normal)))).toList(),
          ),
        );
      },
    );
  }
}
