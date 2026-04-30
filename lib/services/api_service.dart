import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static Future<String?> get token async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<Map<String, String>> _headers() async {
    final t = await token;
    return {
      'Content-Type': 'application/json',
      if (t != null) 'Authorization': 'Bearer $t',
    };
  }

  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    final response = await http.get(url, headers: await _headers());
    return jsonDecode(response.body);
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    final response = await http.post(url, headers: await _headers(), body: jsonEncode(body));
    return jsonDecode(response.body);
  }

  static Future<dynamic> uploadFile(String endpoint, List<int> bytes, String filename) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    final request = http.MultipartRequest('POST', url);
    final t = await token;
    if (t != null) request.headers['Authorization'] = 'Bearer $t';
    request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    return jsonDecode(respStr);
  }

  // Auth
  static Future<dynamic> requestCode(String phone) => post('request-code', {'phoneNumber': phone});
  static Future<dynamic> verifyCode(String phone, String code) => post('verify-code', {'phoneNumber': phone, 'code': code});
  static Future<dynamic> updateProfile(Map<String, dynamic> data) => post('update-profile', data);

  // Users
  static Future<dynamic> getUsers() => get('users');

  // Messages
  static Future<dynamic> getMessages(String userId) => get('messages/$userId');
  static Future<dynamic> sendMessage(Map<String, dynamic> data) => post('messages', data);

  // Chats
  static Future<dynamic> getChats() => get('chats');
}
