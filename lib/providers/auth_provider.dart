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

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get userId => _userId;
  String? get fullName => _fullName;
  String? get phoneNumber => _phoneNumber;
  String? get photoUrl => _photoUrl;
  String? get username => _username;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _isLoggedIn = _token != null;
    _userId = prefs.getString('user_id');
    _fullName = prefs.getString('full_name');
    _phoneNumber = prefs.getString('phone_number');
    _photoUrl = prefs.getString('photo_url');
    _username = prefs.getString('username');
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

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_id', _userId!);
        if (_fullName != null) await prefs.setString('full_name', _fullName!);
        if (_username != null) await prefs.setString('username', _username!);
        if (_photoUrl != null) await prefs.setString('photo_url', _photoUrl!);

        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (_) {}
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
    if (photoUrl != null) _photoUrl = photoUrl;

    final prefs = await SharedPreferences.getInstance();
    if (fullName != null) await prefs.setString('full_name', fullName);
    if (username != null) await prefs.setString('username', username);
    if (photoUrl != null) await prefs.setString('photo_url', photoUrl);

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
    notifyListeners();
  }

  String get chatLink => 'https://chat.seend.com/profile/${_username ?? ''}';
}
