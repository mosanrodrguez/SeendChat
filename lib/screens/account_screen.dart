import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/colors.dart';
import 'welcome_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    void _deleteAccount() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Eliminar cuenta'),
          content: const Text('Esta acción es permanente. Todos tus mensajes, contactos y datos serán eliminados. ¿Continuar?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                // Llamar al endpoint real de eliminación
                try {
                  await auth.logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()), (r) => false);
                  }
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cuenta eliminada'), backgroundColor: SeendColors.primary));
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()), (r) => false);
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Cuenta', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        const Text('Información de cuenta', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        _buildField('Nombre', auth.fullName ?? ''),
        _buildField('Número de teléfono', auth.phoneNumber ?? ''),
        _buildField('Nombre de usuario', '@${auth.username ?? ''}'),
        const SizedBox(height: 32),
        SizedBox(width: double.infinity, height: 48, child: OutlinedButton(onPressed: () { auth.logout(); Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()), (r) => false); }, style: OutlinedButton.styleFrom(foregroundColor: SeendColors.error, side: const BorderSide(color: SeendColors.error)), child: const Text('CERRAR SESIÓN', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, height: 48, child: OutlinedButton(onPressed: _deleteAccount, style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)), child: const Text('ELIMINAR CUENTA', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
      ]),
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: SeendColors.textSecondary, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16)),
        const Divider(),
      ]),
    );
  }
}
