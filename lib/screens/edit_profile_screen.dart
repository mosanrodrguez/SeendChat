import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../config/colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _infoCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  File? _image;
  bool _modified = false;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _nameCtrl.text = auth.fullName ?? '';
    _infoCtrl.text = auth.info ?? '¡Hola! Estoy usando Seend.';
    _userCtrl.text = '@${auth.username ?? ''}';
  }

  void _onChanged() => setState(() => _modified = true);

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) setState(() { _image = File(picked.path); _modified = true; });
  }

  Future<void> _save() async {
    setState(() => _uploading = true);
    String? photoUrl;

    if (_image != null) {
      try {
        final bytes = await _image!.readAsBytes();
        final response = await ApiService.uploadFile('upload', bytes, 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
        if (response != null && response['url'] != null) photoUrl = response['url'];
      } catch (_) {}
    }

    await context.read<AuthProvider>().updateProfile(
      fullName: _nameCtrl.text,
      username: _userCtrl.text.replaceAll('@', ''),
      info: _infoCtrl.text,
      photoUrl: photoUrl,
    );

    if (mounted) {
      setState(() => _uploading = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Editar perfil', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          actions: [if (_modified) TextButton(onPressed: _uploading ? null : _save, child: const Text('Guardar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)))],
        ),
        body: ListView(padding: const EdgeInsets.all(24), children: [
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Stack(children: [
                CircleAvatar(radius: 56, backgroundColor: SeendColors.primary, backgroundImage: _image != null ? FileImage(_image!) : null, child: _image == null ? Text((_nameCtrl.text.isNotEmpty ? _nameCtrl.text[0].toUpperCase() : '?'), style: const TextStyle(fontSize: 40, color: Colors.white)) : null),
                Positioned(bottom: 0, right: 0, child: Container(width: 32, height: 32, decoration: BoxDecoration(color: SeendColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.camera_alt, color: Colors.white, size: 16))),
              ]),
            ),
          ),
          const SizedBox(height: 24),
          TextField(controller: _nameCtrl, onChanged: (_) => _onChanged(), decoration: const InputDecoration(labelText: 'Nombre')),
          const SizedBox(height: 16),
          TextField(controller: _infoCtrl, onChanged: (_) => _onChanged(), decoration: const InputDecoration(labelText: 'Info'), maxLines: 2),
          const SizedBox(height: 16),
          TextField(controller: _userCtrl, onChanged: (_) => _onChanged(), decoration: const InputDecoration(labelText: 'Nombre de usuario')),
        ]),
      ),
      if (_uploading) Container(color: Colors.black45, child: const Center(child: CircularProgressIndicator(color: SeendColors.primary))),
    ]);
  }
}
