import 'package:flutter/material.dart';
import '../config/colors.dart';

class EmojiPicker extends StatelessWidget {
  final Function(String) onEmojiSelected;
  final VoidCallback onClose;

  const EmojiPicker({
    super.key,
    required this.onEmojiSelected,
    required this.onClose,
  });

  static const List<String> _emojis = [
    '😀', '😃', '😄', '😁', '😅', '🤣', '😂', '🙂', '😊', '😇',
    '😍', '🤩', '😎', '😢', '😡', '👍', '🙏', '🎉', '🔥', '💯',
    '❤️', '💙', '💚', '💛', '🧡', '💜', '🖤', '🤍', '🤎', '💔',
    '😋', '😜', '🤪', '😝', '🤑', '🤗', '🤭', '🤫', '🤔', '😐',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: SeendColors.border, width: 0.5)),
      ),
      child: Column(
        children: [
          // Tabs
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildTab('Emojis', true),
                const SizedBox(width: 16),
                _buildTab('Stickers', false),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
          // Emoji grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 8,
              padding: const EdgeInsets.all(8),
              children: _emojis.map((emoji) {
                return GestureDetector(
                  onTap: () => onEmojiSelected(emoji),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool active) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: active ? FontWeight.w600 : FontWeight.normal,
        color: active ? SeendColors.primary : SeendColors.textSecondary,
      ),
    );
  }
}
