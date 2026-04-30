import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/colors.dart';
import 'country_code_screen.dart';
import 'verification_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});
  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  String _countryCode = '+1';
  String _countryFlag = 'US';
  bool _isLoading = false;

  String _flagEmoji(String code) {
    if (code.length != 2) return '';
    return String.fromCharCode(code.codeUnitAt(0) - 0x41 + 0x1F1E6) +
        String.fromCharCode(code.codeUnitAt(1) - 0x41 + 0x1F1E6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              const Text(
                'Iniciar',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: SeendColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Para continuar, ingresa tu número de teléfono.',
                style: TextStyle(fontSize: 14, color: SeendColors.textSecondary),
              ),
              const SizedBox(height: 32),
              // Inputs
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CountryCodeScreen()),
                      );
                      if (result != null && mounted) {
                        setState(() {
                          _countryCode = result['code'];
                          _countryFlag = result['flag'];
                        });
                      }
                    },
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: SeendColors.border)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_flagEmoji(_countryFlag), style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 4),
                          Text(_countryCode, style: const TextStyle(fontSize: 15)),
                          const Icon(Icons.arrow_drop_down, size: 18, color: SeendColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Número de teléfono',
                        hintStyle: TextStyle(fontSize: 15, color: SeendColors.textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Botón
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          final phone = _phoneController.text.trim();
                          if (phone.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ingresa tu número'), backgroundColor: SeendColors.error),
                            );
                            return;
                          }
                          setState(() => _isLoading = true);
                          context.read<AuthProvider>().requestCode('$_countryCode$phone');
                          Future.delayed(const Duration(seconds: 1), () {
                            if (mounted) {
                              setState(() => _isLoading = false);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const VerificationScreen()));
                            }
                          });
                        },
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('SIGUIENTE', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              if (_isLoading) ...[
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border.all(color: SeendColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: SeendColors.primary)),
                        SizedBox(width: 10),
                        Text('Conectando...', style: TextStyle(fontSize: 13, color: SeendColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
