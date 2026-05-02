import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _logged = false, _loading = false;
  String? _t, _uid, _name, _phone, _photo, _username, _info;

  bool get isLoggedIn => _logged; bool get isLoading => _loading;
  String? get token => _t; String? get userId => _uid; String? get fullName => _name;
  String? get phoneNumber => _phone; String? get photoUrl => _photo;
  String? get username => _username; String? get info => _info;

  Future<void> init() async { final p = await SharedPreferences.getInstance(); _t = p.getString('auth_token'); _logged = _t != null && _t!.isNotEmpty; _uid = p.getString('user_id'); _name = p.getString('full_name'); _phone = p.getString('phone_number'); _photo = p.getString('photo_url'); _username = p.getString('username'); _info = p.getString('info'); notifyListeners(); }

  Future<void> requestCode(String phone) async { _loading = true; _phone = phone; notifyListeners(); await ApiService.requestCode(phone); _loading = false; notifyListeners(); }

  Future<bool> verifyCode(String code) async {
    _loading = true; notifyListeners();
    try {
      final r = await ApiService.verifyCode(_phone!, code);
      if (r['token'] != null) { _t = r['token']; _uid = r['user']['id']; _name = r['user']['fullName']; _username = r['user']['username']; _photo = r['user']['photoUrl']; _info = r['user']['info']; final p = await SharedPreferences.getInstance(); await p.setString('auth_token', _t!); await p.setString('user_id', _uid!); if (_name != null) await p.setString('full_name', _name!); if (_username != null) await p.setString('username', _username!); if (_phone != null) await p.setString('phone_number', _phone!); if (_photo != null) await p.setString('photo_url', _photo!); if (_info != null) await p.setString('info', _info!); _logged = true; _loading = false; notifyListeners(); return true; }
    } catch (_) {}
    _loading = false; notifyListeners(); return false;
  }

  Future<void> updateProfile({String? fullName, String? username, String? info, String? photoUrl}) async {
    final data = <String, dynamic>{}; if (fullName != null) data['fullName'] = fullName; if (username != null) data['username'] = username; if (info != null) data['info'] = info; if (photoUrl != null) data['photoUrl'] = photoUrl;
    await ApiService.updateProfile(data);
    if (fullName != null) _name = fullName; if (username != null) _username = username; if (info != null) _info = info; if (photoUrl != null) _photo = photoUrl;
    final p = await SharedPreferences.getInstance(); if (fullName != null) await p.setString('full_name', fullName); if (username != null) await p.setString('username', username); if (info != null) await p.setString('info', info!); if (photoUrl != null) await p.setString('photo_url', photoUrl);
    notifyListeners();
  }

  Future<void> logout() async { final p = await SharedPreferences.getInstance(); await p.clear(); _logged = false; _t = null; _uid = null; _name = null; _phone = null; _photo = null; _username = null; _info = null; notifyListeners(); }

  String get chatLink => 'https://chat.seend.com/profile/${_username ?? ''}';
}
