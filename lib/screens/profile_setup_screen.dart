import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/colors.dart';
import 'home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final username = _userCtrl.text.trim().replaceAll('@', '');

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa tu nombre'), backgroundColor: SeendColors.error));
      return;
    }
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Escoge un nombre de usuario'), backgroundColor: SeendColors.error));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await context.read<AuthProvider>().updateProfile(fullName: name, username: username);
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error de conexión'), backgroundColor: SeendColors.error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(children: [
                const SizedBox(height: 8),
                Align(alignment: Alignment.centerLeft, child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context), padding: EdgeInsets.zero)),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(children: [
                      CircleAvatar(radius: 50, backgroundColor: SeendColors.primary, backgroundImage: _image != null ? FileImage(_image!) : null, child: _image == null ? const Text('S', style: TextStyle(fontSize: 40, color: Colors.white)) : null),
                      Positioned(bottom: 0, right: 0, child: Container(width: 32, height: 32, decoration: BoxDecoration(color: SeendColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.camera_alt, color: Colors.white, size: 16))),
                    ]),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('(opcional)', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary)),
                const SizedBox(height: 32),
                TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Tu nombre *', hintText: 'Obligatorio')),
                const SizedBox(height: 16),
                TextField(controller: _userCtrl, decoration: const InputDecoration(labelText: 'Nombre de usuario *', hintText: '@usuario', helperText: 'Será tu ID único. Obligatorio.')),
                const SizedBox(height: 40),
                SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: _save, child: const Text('GUARDAR Y CONTINUAR', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black45,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(16)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: SeendColors.primary)),
                  SizedBox(width: 12),
                  Text('Iniciando...', style: TextStyle(fontSize: 14, color: SeendColors.textSecondary)),
                ]),
              ),
            ),
          ),
      ],
    );
  }
}
