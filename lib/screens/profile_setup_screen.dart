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
  final _lastCtrl = TextEditingController();
  File? _image;
  bool _loading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _save({bool skip = false}) async {
    setState(() => _loading = true);
    final name = skip ? 'Usuario Seend' : '${_nameCtrl.text.trim()} ${_lastCtrl.text.trim()}'.trim();
    await context.read<AuthProvider>().updateProfile(fullName: name.isEmpty ? 'Usuario Seend' : name);
    if (mounted) {
      setState(() => _loading = false);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false);
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
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Align(alignment: Alignment.centerLeft, child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context), padding: EdgeInsets.zero)),
                  const SizedBox(height: 24),
                  // Avatar
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: SeendColors.primary,
                            backgroundImage: _image != null ? FileImage(_image!) : null,
                            child: _image == null ? const Text('S', style: TextStyle(fontSize: 40, color: Colors.white)) : null,
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(color: SeendColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('(opcional)', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary)),
                  const SizedBox(height: 32),
                  TextField(controller: _nameCtrl, decoration: const InputDecoration(hintText: 'Tu nombre')),
                  const SizedBox(height: 16),
                  TextField(controller: _lastCtrl, decoration: const InputDecoration(hintText: 'Tu apellido (opcional)')),
                  const SizedBox(height: 40),
                  SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: () => _save(), child: const Text('GUARDAR Y CONTINUAR', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
                  const SizedBox(height: 12),
                  TextButton(onPressed: () => _save(skip: true), child: const Text('Omitir', style: TextStyle(fontSize: 13, color: SeendColors.textSecondary))),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
        if (_loading)
          Container(
            color: Colors.black45,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(8)),
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
