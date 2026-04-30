import 'package:flutter/material.dart';
import '../config/colors.dart';

class CountryCodeScreen extends StatefulWidget {
  const CountryCodeScreen({super.key});
  @override
  State<CountryCodeScreen> createState() => _CountryCodeScreenState();
}

class _CountryCodeScreenState extends State<CountryCodeScreen> {
  final _searchController = TextEditingController();
  final _countries = [
    {'code': '+1', 'name': 'Estados Unidos', 'flag': 'US'},
    {'code': '+52', 'name': 'México', 'flag': 'MX'},
    {'code': '+34', 'name': 'España', 'flag': 'ES'},
    {'code': '+54', 'name': 'Argentina', 'flag': 'AR'},
    {'code': '+57', 'name': 'Colombia', 'flag': 'CO'},
    {'code': '+53', 'name': 'Cuba', 'flag': 'CU'},
    {'code': '+56', 'name': 'Chile', 'flag': 'CL'},
    {'code': '+51', 'name': 'Perú', 'flag': 'PE'},
    {'code': '+58', 'name': 'Venezuela', 'flag': 'VE'},
    {'code': '+55', 'name': 'Brasil', 'flag': 'BR'},
    {'code': '+49', 'name': 'Alemania', 'flag': 'DE'},
    {'code': '+33', 'name': 'Francia', 'flag': 'FR'},
    {'code': '+39', 'name': 'Italia', 'flag': 'IT'},
    {'code': '+44', 'name': 'Reino Unido', 'flag': 'GB'},
    {'code': '+81', 'name': 'Japón', 'flag': 'JP'},
    {'code': '+86', 'name': 'China', 'flag': 'CN'},
  ];
  late List<Map<String, String>> _filtered = _countries;

  String _flag(String c) => c.length != 2 ? '' : String.fromCharCode(c.codeUnitAt(0) - 0x41 + 0x1F1E6) + String.fromCharCode(c.codeUnitAt(1) - 0x41 + 0x1F1E6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Seleccionar país'),
        backgroundColor: SeendColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _filtered = _countries.where((c) => c['name']!.toLowerCase().contains(v.toLowerCase()) || c['code']!.contains(v)).toList()),
              decoration: const InputDecoration(
                hintText: 'Buscar país...',
                prefixIcon: Icon(Icons.search, color: SeendColors.textSecondary),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final c = _filtered[i];
                return ListTile(
                  leading: Text(_flag(c['flag']!), style: const TextStyle(fontSize: 24)),
                  title: Text(c['name']!),
                  trailing: Text(c['code']!, style: const TextStyle(color: SeendColors.textSecondary)),
                  onTap: () => Navigator.pop(context, c),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
