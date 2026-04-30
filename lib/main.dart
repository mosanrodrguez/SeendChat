import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/presence_provider.dart';
import 'providers/websocket_provider.dart';
import 'providers/status_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar AuthProvider ANTES de ejecutar la app
  final authProvider = AuthProvider();
  authProvider.init().then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authProvider),
          ChangeNotifierProvider(create: (_) => ChatProvider()),
          ChangeNotifierProvider(create: (_) => PresenceProvider()),
          ChangeNotifierProvider(create: (_) => WebSocketProvider()),
          ChangeNotifierProvider(create: (_) => StatusProvider()..loadDummyData()),
        ],
        child: const SeendApp(),
      ),
    );
  });
}
