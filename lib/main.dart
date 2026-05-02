import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/presence_provider.dart';
import 'providers/websocket_provider.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authProvider = AuthProvider();
  await authProvider.init();

  // Inicializar notificaciones
  await FirebaseService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => PresenceProvider()),
        ChangeNotifierProvider(create: (_) => WebSocketProvider()),
      ],
      child: const SeendApp(),
    ),
  );
}
