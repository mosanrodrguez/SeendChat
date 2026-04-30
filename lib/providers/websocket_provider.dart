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
  Function(String, bool)? onRecording;

  String get status => _status;
  bool get isOnline => _status == 'online';

  void connect(String token, {
    Function(Message)? onMessage,
    Function(String, bool)? onTypingCallback,
    Function(String, bool)? onRecordingCallback,
  }) {
    onNewMessage = onMessage;
    onTyping = onTypingCallback;
    onRecording = onRecordingCallback;
    _status = 'connecting';
    notifyListeners();

    try {
      _channel = WebSocketChannel.connect(Uri.parse(ApiConfig.wsUrl));
      _channel!.stream.listen(
        (data) {
          final json = jsonDecode(data);
          switch (json['type']) {
            case 'auth_ok':
              _status = 'online';
              notifyListeners();
              break;
            case 'new_message':
              onNewMessage?.call(Message.fromJson(json['message']));
              break;
            case 'typing':
              onTyping?.call(json['userId'], json['isTyping']);
              break;
            case 'recording':
              onRecording?.call(json['userId'], json['isRecording']);
              break;
          }
        },
        onError: (_) {
          _status = 'offline';
          notifyListeners();
          Future.delayed(const Duration(seconds: 5), () => connect(token, onMessage: onMessage));
        },
        onDone: () {
          _status = 'offline';
          notifyListeners();
        },
      );
      _channel!.sink.add(jsonEncode({'type': 'auth', 'token': token}));
    } catch (_) {
      _status = 'offline';
      notifyListeners();
    }
  }

  void sendMessage(String receiverId, String text) {
    _channel?.sink.add(jsonEncode({'type': 'message', 'receiverId': receiverId, 'text': text}));
  }

  void sendTyping(String receiverId, bool isTyping) {
    _channel?.sink.add(jsonEncode({'type': 'typing', 'receiverId': receiverId, 'isTyping': isTyping}));
  }

  void disconnect() {
    _channel?.sink.close();
    _status = 'offline';
    notifyListeners();
  }
}
