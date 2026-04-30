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
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return MaterialApp(
          title: 'Seend',
          debugShowCheckedModeBanner: false,
          theme: SeendTheme.light,
          darkTheme: SeendTheme.dark,
          themeMode: ThemeMode.system,
          home: auth.isLoggedIn ? const HomeScreen() : const WelcomeScreen(),
        );
      },
    );
  }
}
