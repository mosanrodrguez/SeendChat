import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';

class SeendApp extends StatelessWidget {
  const SeendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seend',
      debugShowCheckedModeBanner: false,
      theme: SeendTheme.light,
      darkTheme: SeendTheme.dark,
      themeMode: ThemeMode.system,
      // Transición personalizada entre pantallas
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isLoggedIn) return const HomeScreen();
          return const WelcomeScreen();
        },
      ),
    );
  }
}
