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
    return {'Content-Type': 'application/json', if (t != null) 'Authorization': 'Bearer $t'};
  }

  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    final response = await http.get(url, headers: await _headers()).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Error ${response.statusCode}');
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    final response = await http.post(url, headers: await _headers(), body: jsonEncode(body)).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200 || response.statusCode == 201) return jsonDecode(response.body);
    throw Exception('Error ${response.statusCode}');
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    final response = await http.put(url, headers: await _headers(), body: jsonEncode(body)).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Error ${response.statusCode}');
  }

  static Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    final response = await http.delete(url, headers: await _headers()).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Error ${response.statusCode}');
  }

  static Future<dynamic> uploadFile(String endpoint, List<int> bytes, String filename) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    final request = http.MultipartRequest('POST', url);
    final t = await token;
    if (t != null) request.headers['Authorization'] = 'Bearer $t';
    request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
    final response = await request.send().timeout(const Duration(seconds: 30));
    final respStr = await response.stream.bytesToString();
    return jsonDecode(respStr);
  }

  static Future<dynamic> requestCode(String phone) => post('request-code', {'phoneNumber': phone});
  static Future<dynamic> verifyCode(String phone, String code) => post('verify-code', {'phoneNumber': phone, 'code': code});
  static Future<dynamic> updateProfile(Map<String, dynamic> data) => post('update-profile', data);
  static Future<dynamic> getUsers() => get('users');
  static Future<dynamic> getUser(String id) => get('users/$id');
  static Future<dynamic> getMessages(String userId) => get('messages/$userId');
  static Future<dynamic> sendMessage(Map<String, dynamic> data) => post('messages', data);
  static Future<dynamic> getChats() => get('chats');
  static Future<dynamic> createGroup(Map<String, dynamic> data) => post('groups', data);
  static Future<dynamic> getGroups() => get('groups');
  static Future<dynamic> getPrivacy() => get('privacy');
  static Future<dynamic> updatePrivacy(Map<String, dynamic> data) => put('privacy', data);
  static Future<dynamic> getBlocked() => get('blocked');
  static Future<dynamic> blockUser(String userId) => post('block', {'blockedUserId': userId});
  static Future<dynamic> unblockUser(String userId) => delete('block/$userId');
}
