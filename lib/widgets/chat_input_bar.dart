import 'package:flutter/material.dart';
import '../config/colors.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final VoidCallback onEmoji;
  final Function(String)? onTextChanged;
  final Function(String)? onVoiceSent;

  const ChatInputBar({super.key, required this.controller, required this.onSend, required this.onAttach, required this.onEmoji, this.onTextChanged, this.onVoiceSent});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool _isRecording = false;
  int _recordSeconds = 0;

  bool get _hasText => widget.controller.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, border: Border(top: BorderSide(color: SeendColors.border, width: 0.5))),
      child: Row(children: [
        IconButton(icon: const Icon(Icons.emoji_emotions_outlined, size: 22, color: SeendColors.textSecondary), onPressed: widget.onEmoji, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 40, minHeight: 40)),
        Expanded(child: TextField(controller: widget.controller, maxLines: 4, minLines: 1, style: const TextStyle(fontSize: 14), decoration: InputDecoration(hintText: 'Mensaje', hintStyle: const TextStyle(fontSize: 14, color: SeendColors.textSecondary), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none), filled: true, fillColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)), onChanged: (v) { setState(() {}); widget.onTextChanged?.call(v); })),
        const SizedBox(width: 4),
        IconButton(icon: const Icon(Icons.attach_file, size: 22, color: SeendColors.textSecondary), onPressed: widget.onAttach, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 40, minHeight: 40)),
        _hasText ? Container(width: 40, height: 40, decoration: const BoxDecoration(color: SeendColors.primary, shape: BoxShape.circle), child: IconButton(icon: const Icon(Icons.send_rounded, size: 18, color: Colors.white), onPressed: widget.onSend, padding: EdgeInsets.zero)) : Container(width: 40, height: 40, decoration: const BoxDecoration(color: SeendColors.primary, shape: BoxShape.circle), child: IconButton(icon: const Icon(Icons.mic, size: 18, color: Colors.white), onPressed: () {}, padding: EdgeInsets.zero)),
      ]),
    );
  }
}
