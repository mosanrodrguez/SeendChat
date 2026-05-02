import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config/api_config.dart';
import '../models/message.dart';

class WebSocketProvider extends ChangeNotifier {
  WebSocketChannel? _channel;
  String _status = 'offline';
  Function(Message)? onNewMessage;
  Function(String, bool)? onTyping;

  String get status => _status;
  bool get isOnline => _status == 'online';

  void connect(String token, {
    Function(Message)? onMessage,
    Function(String, bool)? onTypingCallback,
  }) {
    onNewMessage = onMessage;
    onTyping = onTypingCallback;
    _status = 'connecting';
    notifyListeners();

    try {
      _channel = WebSocketChannel.connect(Uri.parse(ApiConfig.wsUrl));
      _channel!.stream.listen(
        (data) {
          final json = jsonDecode(data);
          switch (json['type']) {
            case 'auth_ok': _status = 'online'; notifyListeners(); break;
            case 'new_message': onNewMessage?.call(Message.fromJson(json['message'])); break;
            case 'message_delivered': break;
            case 'messages_read': break;
            case 'typing': onTyping?.call(json['userId'], json['isTyping']); break;
          }
        },
        onError: (_) { _status = 'offline'; notifyListeners(); Future.delayed(const Duration(seconds: 5), () => connect(token, onMessage: onMessage, onTypingCallback: onTypingCallback)); },
        onDone: () { _status = 'offline'; notifyListeners(); },
      );
      _channel!.sink.add(jsonEncode({'type': 'auth', 'token': token}));
    } catch (_) { _status = 'offline'; notifyListeners(); }
  }

  void sendMessage(String receiverId, String text, {String? replyTo, String? replyText}) {
    _channel?.sink.add(jsonEncode({'type': 'message', 'receiverId': receiverId, 'text': text, 'replyTo': replyTo, 'replyText': replyText}));
  }

  void sendTyping(String receiverId, bool isTyping) {
    _channel?.sink.add(jsonEncode({'type': 'typing', 'receiverId': receiverId, 'isTyping': isTyping}));
  }

  void disconnect() { _channel?.sink.close(); _status = 'offline'; notifyListeners(); }
}
