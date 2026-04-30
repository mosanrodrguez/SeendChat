import 'package:flutter/material.dart';
import '../config/colors.dart';

class CreateStatusScreen extends StatelessWidget {
  const CreateStatusScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Crear estado', style: TextStyle(color: Colors.white))),
      body: Center(child: Text('Cámara para crear estado', style: TextStyle(fontSize: 14, color: Colors.white70))),
    );
  }
}
