import 'package:flutter/material.dart';
import '../services/xmpp_service.dart';

class XmppProvider extends ChangeNotifier {
  final XmppService _service = XmppService();

  String _status = 'offline';

  String get status => _status;
  bool get isOnline => _status == 'online';

  Future<void> connect(String username, String password) async {
    _status = 'connecting';
    notifyListeners();
    await _service.connect(username, password);
    _status = _service.status;
    notifyListeners();
  }

  Future<void> disconnect() async {
    await _service.disconnect();
    _status = 'offline';
    notifyListeners();
  }

  Future<bool> register(String username, String password) async {
    return await _service.register(username, password);
  }

  Future<void> sendMessage(String to, String message) async {
    await _service.sendMessage(to, message);
  }

  Future<void> sendTyping(String to, bool isTyping) async {
    await _service.sendTyping(to, isTyping);
  }
}
