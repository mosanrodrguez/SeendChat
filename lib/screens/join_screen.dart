import 'package:flutter/material.dart';
import '../config/colors.dart';

class JoinScreen extends StatelessWidget {
  final bool isGroup;
  final String name;
  final String? photoUrl;
  final String? description;

  const JoinScreen({
    super.key,
    required this.isGroup,
    required this.name,
    this.photoUrl,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 48, backgroundColor: SeendColors.primary, child: Icon(isGroup ? Icons.group : Icons.campaign, color: Colors.white, size: 36)),
              const SizedBox(height: 16),
              Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(isGroup ? 'Grupo' : 'Canal', style: const TextStyle(fontSize: 14, color: SeendColors.textSecondary)),
              if (description != null) ...[
                const SizedBox(height: 16),
                Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(border: Border.all(color: SeendColors.border), borderRadius: BorderRadius.circular(8)), child: Text(description!, style: const TextStyle(fontSize: 14), textAlign: TextAlign.center)),
              ],
              if (!isGroup) ...[
                const SizedBox(height: 12),
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: SeendColors.border), borderRadius: BorderRadius.circular(4)), child: const Row(children: [Icon(Icons.lock, size: 16, color: SeendColors.textSecondary), SizedBox(width: 8), Expanded(child: Text('Solo los administradores pueden enviar mensajes', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary)))])),
              ],
              const SizedBox(height: 32),
              SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: Text(isGroup ? 'UNIRME AL GRUPO' : 'SUSCRIBIRME', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
              const SizedBox(height: 12),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(fontSize: 13, color: SeendColors.textSecondary))),
            ],
          ),
        ),
      ),
    );
  }
}
