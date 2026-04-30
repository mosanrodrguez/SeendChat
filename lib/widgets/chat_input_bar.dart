import 'package:flutter/material.dart';
import '../config/colors.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final VoidCallback onEmoji;
  final VoidCallback? onMicStart;
  final VoidCallback? onMicEnd;
  final Function(String)? onTextChanged;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onAttach,
    required this.onEmoji,
    this.onMicStart,
    this.onMicEnd,
    this.onTextChanged,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool get _hasText => widget.controller.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
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
            : IconButton(icon: const Icon(Icons.mic_none, size: 22, color: SeendColors.textSecondary), onPressed: widget.onMicStart, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 40, minHeight: 40)),
      ]),
    );
  }
}
