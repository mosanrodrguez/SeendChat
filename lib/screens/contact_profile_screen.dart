import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/call_provider.dart';
import '../config/colors.dart';
import 'chat_screen.dart';
import 'call_screen.dart';

class ContactProfileScreen extends StatelessWidget {
  final String userId;
  final String userName;
  final String? userPhoto;
  const ContactProfileScreen({super.key, required this.userId, required this.userName, this.userPhoto});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Contacto', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(child: CircleAvatar(radius: 48, backgroundColor: SeendColors.primary, child: Text(userName.isNotEmpty ? userName[0].toUpperCase() : '?', style: const TextStyle(fontSize: 32, color: Colors.white)))),
          const SizedBox(height: 12),
          Center(child: Text(userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, height: 48, child: ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(userId: userId, userName: userName, userPhoto: userPhoto))), icon: const Icon(Icons.chat_bubble_outline, size: 18), label: const Text('Enviar mensaje', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, height: 48, child: OutlinedButton.icon(onPressed: () { context.read<CallProvider>().startCall(userId, userName); Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen())); }, icon: const Icon(Icons.call, size: 18), label: const Text('Llamar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
        ],
      ),
    );
  }
}
