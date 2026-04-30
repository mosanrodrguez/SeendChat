import 'package:flutter/material.dart';
import '../config/colors.dart';
import 'phone_auth_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
              const Spacer(flex: 2),
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: SeendColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 32),
              // Título
              const Text(
                'Bienvenido a Seend',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: SeendColors.primary),
              ),
              const SizedBox(height: 12),
              // Subtítulo
              const Text(
                'Mensajería rápida y segura',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: SeendColors.textSecondary),
              ),
              const Spacer(flex: 2),
              // Botón
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhoneAuthScreen())),
                  child: const Text('COMENCEMOS', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),
              // Términos
              const Text(
                'Al continuar aceptas los Términos y Condiciones',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: SeendColors.textSecondary),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
