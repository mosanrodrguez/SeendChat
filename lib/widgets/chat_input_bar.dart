import 'package:flutter/material.dart';
import '../config/colors.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final VoidCallback onEmoji;
  final Function(String)? onTextChanged;
  final Function(String)? onVoiceSent;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onAttach,
    required this.onEmoji,
    this.onTextChanged,
    this.onVoiceSent,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool _isRecording = false;
  int _recordSeconds = 0;
  double _dragOffset = 0;
  bool _isCancelling = false;

  bool get _hasText => widget.controller.text.trim().isNotEmpty;

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordSeconds = 0;
      _isCancelling = false;
    });
    // Iniciaría la grabación real aquí
  }

  void _stopRecording() {
    if (_isCancelling) {
      setState(() { _isRecording = false; _recordSeconds = 0; });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grabación cancelada'), backgroundColor: SeendColors.error, duration: Duration(seconds: 1)));
    } else {
      final duration = _recordSeconds;
      setState(() { _isRecording = false; _recordSeconds = 0; });
      widget.onVoiceSent?.call('audio_${duration}s');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Audio de ${duration}s enviado'), backgroundColor: SeendColors.primary, duration: const Duration(seconds: 1)));
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
      _isCancelling = _dragOffset < -80;
    });
  }

  @override
  Widget build(BuildContext context) {
    // MODO GRABACIÓN
    if (_isRecording) {
      return GestureDetector(
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: (_) => _stopRecording(),
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isCancelling ? Colors.red.withOpacity(0.1) : Theme.of(context).scaffoldBackgroundColor,
            border: Border(top: BorderSide(color: _isCancelling ? Colors.red : SeendColors.border, width: 0.5)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isCancelling ? 'Suelta para cancelar' : 'Desliza para cancelar',
                style: TextStyle(fontSize: 11, color: _isCancelling ? Colors.red : SeendColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.mic, color: SeendColors.error, size: 28),
                const SizedBox(width: 8),
                Text('0:${_recordSeconds.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Container(width: 100, height: 4, decoration: BoxDecoration(color: SeendColors.primary, borderRadius: BorderRadius.circular(2))),
              ]),
            ],
          ),
        ),
      );
    }

    // MODO NORMAL
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: SeendColors.border, width: 0.5)),
      ),
      child: Row(children: [
        IconButton(icon: const Icon(Icons.emoji_emotions_outlined, size: 22, color: SeendColors.textSecondary), onPressed: widget.onEmoji, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 40, minHeight: 40)),
        Expanded(
          child: TextField(
            controller: widget.controller,
            maxLines: 4, minLines: 1,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(hintText: 'Escribe un mensaje...', hintStyle: TextStyle(fontSize: 14, color: SeendColors.textSecondary), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
            onChanged: (v) {
              setState(() {});
              widget.onTextChanged?.call(v);
            },
          ),
        ),
        IconButton(icon: const Icon(Icons.attach_file, size: 22, color: SeendColors.textSecondary), onPressed: widget.onAttach, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 40, minHeight: 40)),
        _hasText
            ? IconButton(icon: const Icon(Icons.send, size: 22, color: SeendColors.primary), onPressed: widget.onSend, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 40, minHeight: 40))
            : GestureDetector(
                onLongPressStart: (_) => _startRecording(),
                onLongPressEnd: (_) => _stopRecording(),
                child: Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const Icon(Icons.mic_none, size: 22, color: SeendColors.textSecondary),
                ),
              ),
      ]),
    );
  }
}
