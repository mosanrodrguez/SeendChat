import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/colors.dart';
import 'profile_setup_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  Timer? _timer;
  int _secondsLeft = 60;
  bool _canResend = false;

  @override
  void initState() { super.initState(); _startTimer(); }

  void _startTimer() { _canResend = false; _secondsLeft = 60; _timer?.cancel(); _timer = Timer.periodic(const Duration(seconds: 1), (t) { if (_secondsLeft > 0) { setState(() => _secondsLeft--); } else { setState(() => _canResend = true); t.cancel(); }}); }

  Future<void> _verify() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length != 6) return;
    final ok = await context.read<AuthProvider>().verifyCode(code);
    if (ok && mounted) { Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const ProfileSetupScreen()), (r) => false); }
    else if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código incorrecto'), backgroundColor: SeendColors.error)); for (var c in _controllers) c.clear(); _focusNodes[0].requestFocus(); }
  }

  @override
  Widget build(BuildContext context) {
    final phone = context.watch<AuthProvider>().phoneNumber ?? '';
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 8),
        IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context), padding: EdgeInsets.zero),
        const SizedBox(height: 16),
        Text('Verifica tu número', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: SeendColors.textPrimary)),
        const SizedBox(height: 8),
        Text('Ingresa el código que enviamos al', style: const TextStyle(fontSize: 13, color: SeendColors.textSecondary)),
        const SizedBox(height: 4),
        Text(phone, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: SeendColors.primary)),
        const SizedBox(height: 28),
        Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(6, (i) => Container(width: 48, height: 56, margin: const EdgeInsets.symmetric(horizontal: 4), child: TextField(controller: _controllers[i], focusNode: _focusNodes[i], textAlign: TextAlign.center, maxLength: 1, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold), decoration: const InputDecoration(counterText: ''), onChanged: (v) { if (v.isNotEmpty && i < 5) _focusNodes[i + 1].requestFocus(); if (v.isEmpty && i > 0) _focusNodes[i - 1].requestFocus(); if (i == 5 && v.isNotEmpty) _verify(); }))))),
        const SizedBox(height: 16),
        Center(child: GestureDetector(onTap: _canResend ? () { _startTimer(); } : null, child: Text(_canResend ? 'Reenviar código' : 'Reenviar código en 0:${_secondsLeft.toString().padLeft(2, '0')}', style: TextStyle(fontSize: 13, color: _canResend ? SeendColors.primary : SeendColors.textSecondary)))),
        const Spacer(),
        SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: _verify, child: const Text('SIGUIENTE', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
        const SizedBox(height: 16),
      ]))),
    );
  }
}
