import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _token;
  String? _userId;
  String? _fullName;
  String? _phoneNumber;
  String? _photoUrl;
  String? _username;
  String? _info;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get userId => _userId;
  String? get fullName => _fullName;
  String? get phoneNumber => _phoneNumber;
  String? get photoUrl => _photoUrl;
  String? get username => _username;
  String? get info => _info;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _isLoggedIn = _token != null && _token!.isNotEmpty;
    _userId = prefs.getString('user_id');
    _fullName = prefs.getString('full_name');
    _phoneNumber = prefs.getString('phone_number');
    _photoUrl = prefs.getString('photo_url');
    _username = prefs.getString('username');
    _info = prefs.getString('info');
    
    // Debug: verificar qué se cargó
    debugPrint('🟢 AuthProvider.init() - sesión cargada: $_isLoggedIn');
    debugPrint('   Token: ${_token?.substring(0, 20) ?? "null"}...');
    debugPrint('   Usuario: $_fullName (@$_username)');
    debugPrint('   Teléfono: $_phoneNumber');
    
    notifyListeners();
  }

  Future<void> requestCode(String phone) async {
    _isLoading = true;
    _phoneNumber = phone;
    notifyListeners();
    await ApiService.requestCode(phone);
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> verifyCode(String code) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService.verifyCode(_phoneNumber!, code);
      if (response['token'] != null) {
        _token = response['token'];
        _userId = response['user']['id'];
        _fullName = response['user']['fullName'];
        _username = response['user']['username'];
        _photoUrl = response['user']['photoUrl'];
        _info = response['user']['info'];

        final prefs = await SharedPreferences.getInstance();
        // Guardar TODO en SharedPreferences
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_id', _userId!);
        if (_fullName != null) await prefs.setString('full_name', _fullName!);
        if (_username != null) await prefs.setString('username', _username!);
        if (_phoneNumber != null) await prefs.setString('phone_number', _phoneNumber!);
        if (_photoUrl != null) await prefs.setString('photo_url', _photoUrl!);
        if (_info != null) await prefs.setString('info', _info!);

        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        
        debugPrint('✅ Sesión guardada correctamente');
        return true;
      }
    } catch (e) {
      debugPrint('❌ Error en verifyCode: $e');
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> updateProfile({
    String? fullName,
    String? username,
    String? info,
    String? photoUrl,
  }) async {
    final data = <String, dynamic>{};
    if (fullName != null) data['fullName'] = fullName;
    if (username != null) data['username'] = username;
    if (info != null) data['info'] = info;
    if (photoUrl != null) data['photoUrl'] = photoUrl;

    await ApiService.updateProfile(data);

    if (fullName != null) _fullName = fullName;
    if (username != null) _username = username;
    if (info != null) _info = info;
    if (photoUrl != null) _photoUrl = photoUrl;

    final prefs = await SharedPreferences.getInstance();
    if (fullName != null) await prefs.setString('full_name', fullName);
    if (username != null) await prefs.setString('username', username);
    if (info != null) await prefs.setString('info', info!);
    if (photoUrl != null) await prefs.setString('photo_url', photoUrl);

    debugPrint('✅ Perfil actualizado y guardado');
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    _token = null;
    _userId = null;
    _fullName = null;
    _phoneNumber = null;
    _photoUrl = null;
    _username = null;
    _info = null;
    debugPrint('🟡 Sesión cerrada - datos borrados');
    notifyListeners();
  }

  String get chatLink => 'https://chat.seend.com/profile/${_username ?? ''}';
}
