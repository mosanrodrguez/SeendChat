import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../config/colors.dart';

class EmojiPickerWidget extends StatelessWidget {
  final Function(String) onEmojiSelected;
  final VoidCallback onClose;

  const EmojiPickerWidget({super.key, required this.onEmojiSelected, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 300,
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1A1A1A) : Colors.white, border: Border(top: BorderSide(color: SeendColors.border.withOpacity(0.3)))),
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) => onEmojiSelected(emoji.emoji),
        onBackspacePressed: () {},
        config: Config(checkPlatformCompatibility: true),
      ),
    );
  }
}
