import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class VoiceService extends ChangeNotifier {
  bool _isRecording = false;
  int _seconds = 0;
  Timer? _timer;
  String? _currentFilePath;

  bool get isRecording => _isRecording;
  int get seconds => _seconds;
  String get formattedTime => '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}';

  Future<void> startRecording() async {
    _isRecording = true;
    _seconds = 0;
    notifyListeners();

    final dir = await getTemporaryDirectory();
    _currentFilePath = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _seconds++;
      notifyListeners();
    });

    // Aquí se iniciaría la grabación real con flutter_sound o record
    debugPrint('🎤 Grabando en: $_currentFilePath');
  }

  Future<String?> stopRecording() async {
    _isRecording = false;
    _timer?.cancel();
    notifyListeners();

    debugPrint('✅ Grabación finalizada: $_currentFilePath');
    return _currentFilePath;
  }

  void cancelRecording() {
    _isRecording = false;
    _timer?.cancel();
    _seconds = 0;
    notifyListeners();

    if (_currentFilePath != null) {
      File(_currentFilePath!).deleteSync();
    }
    debugPrint('❌ Grabación cancelada');
  }
}
