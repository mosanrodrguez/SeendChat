import 'package:flutter/material.dart';
import '../config/colors.dart';
import 'phone_auth_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Spacer(),
        CircleAvatar(radius: 60, backgroundColor: SeendColors.primary, child: const Icon(Icons.chat, size: 55, color: Colors.white)),
        const SizedBox(height: 40),
        const Text('Te damos la bienvenida a Seend', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const Padding(padding: EdgeInsets.all(20), child: Text('Lee nuestra Política de privacidad. Toca "Aceptar y continuar" para aceptar las Condiciones de servicio.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
        const Spacer(),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40), child: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: SeendColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 16)), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhoneAuthScreen())), child: const Text('Aceptar y continuar', style: TextStyle(color: Colors.white, fontSize: 16))))),
      ]),
    );
  }
}
