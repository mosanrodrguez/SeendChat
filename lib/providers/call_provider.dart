import 'dart:async';
import 'package:flutter/material.dart';

enum CallState { idle, calling, ringing, connecting, inProgress, ended }

class CallProvider extends ChangeNotifier {
  CallState _state = CallState.idle;
  String? _callerId;
  String? _callerName;
  String? _callerPhoto;
  bool _isVideo = false;
  bool _isMicEnabled = true;
  bool _isSpeakerEnabled = false;
  bool _isCameraEnabled = false;
  int _seconds = 0;
  Timer? _timer;

  CallState get state => _state;
  String? get callerId => _callerId;
  String? get callerName => _callerName;
  String? get callerPhoto => _callerPhoto;
  bool get isVideo => _isVideo;
  bool get isMicEnabled => _isMicEnabled;
  bool get isSpeakerEnabled => _isSpeakerEnabled;
  bool get isCameraEnabled => _isCameraEnabled;
  int get seconds => _seconds;
  String get formattedTime {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void startCall(String callerId, String callerName, {String? callerPhoto, bool isVideo = false}) {
    _callerId = callerId;
    _callerName = callerName;
    _callerPhoto = callerPhoto;
    _isVideo = isVideo;
    _state = CallState.calling;
    notifyListeners();
  }

  void incomingCall(String callerId, String callerName, {String? callerPhoto}) {
    _callerId = callerId;
    _callerName = callerName;
    _callerPhoto = callerPhoto;
    _isVideo = false;
    _state = CallState.ringing;
    notifyListeners();
  }

  void onConnected() {
    _state = CallState.inProgress;
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _seconds++;
      notifyListeners();
    });
    notifyListeners();
  }

  void toggleMic() {
    _isMicEnabled = !_isMicEnabled;
    notifyListeners();
  }

  void toggleSpeaker() {
    _isSpeakerEnabled = !_isSpeakerEnabled;
    notifyListeners();
  }

  void toggleCamera() {
    _isCameraEnabled = !_isCameraEnabled;
    notifyListeners();
  }

  void endCall() {
    _timer?.cancel();
    _state = CallState.ended;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      _state = CallState.idle;
      _callerId = null;
      _callerName = null;
      _callerPhoto = null;
      _seconds = 0;
      notifyListeners();
    });
  }
}
