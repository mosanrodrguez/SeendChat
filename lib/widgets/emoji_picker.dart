import 'package:flutter/material.dart';
import '../config/colors.dart';

class EmojiPicker extends StatefulWidget {
  final Function(String) onEmojiSelected;
  final VoidCallback onClose;

  const EmojiPicker({super.key, required this.onEmojiSelected, required this.onClose});

  @override
  State<EmojiPicker> createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showStickerCreator = false;

  static const List<String> _emojis = [
    '😀', '😃', '😄', '😁', '😅', '🤣', '😂', '🙂', '😊', '😇',
    '😍', '🤩', '😎', '😢', '😡', '👍', '🙏', '🎉', '🔥', '💯',
    '❤️', '💙', '💚', '💛', '🧡', '💜', '🖤', '🤍', '🤎', '💔',
    '😋', '😜', '🤪', '😝', '🤑', '🤗', '🤭', '🤫', '🤔', '😐',
    '🐱', '🐶', '🦊', '🐸', '🦁', '🐵', '🦄', '🐝', '🌸', '🌈',
    '🍕', '🍔', '🌮', '🍩', '🎂', '☕', '🍺', '🍷', '🎸', '⚽',
  ];

  // Stickers predefinidos (emojis grandes)
  static const List<String> _stickers = [
    '😍', '🤩', '🔥', '💯', '❤️', '🎉',
    '😂', '😢', '👍', '🙏', '💪', '🌟',
  ];

  final List<String> _customStickers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _addCustomSticker() {
    setState(() => _showStickerCreator = true);
  }

  void _createStickerFromEmoji(String emoji) {
    setState(() {
      _customStickers.add(emoji);
      _showStickerCreator = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sticker $emoji creado'), backgroundColor: SeendColors.primary, duration: const Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, border: Border(top: BorderSide(color: SeendColors.border, width: 0.5))),
      child: Column(children: [
        // Tabs
        Container(
          height: 44,
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: SeendColors.border, width: 0.5))),
          child: Row(children: [
            const SizedBox(width: 12),
            _buildTab('Emojis', 0),
            const SizedBox(width: 20),
            _buildTab('Stickers', 1),
            const Spacer(),
            IconButton(icon: const Icon(Icons.close, size: 18, color: SeendColors.textSecondary), onPressed: widget.onClose, padding: EdgeInsets.zero),
            const SizedBox(width: 8),
          ]),
        ),
        // Contenido
        Expanded(
          child: _showStickerCreator
              ? _buildStickerCreator()
              : TabBarView(controller: _tabController, children: [
                  _buildEmojiGrid(),
                  _buildStickerGrid(),
                ]),
        ),
      ]),
    );
  }

  Widget _buildTab(String title, int index) {
    final isActive = _tabController.index == index;
    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: Text(title, style: TextStyle(fontSize: 13, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal, color: isActive ? SeendColors.primary : SeendColors.textSecondary)),
    );
  }

  Widget _buildEmojiGrid() {
    return GridView.count(
      crossAxisCount: 8,
      padding: const EdgeInsets.all(8),
      children: _emojis.map((emoji) => GestureDetector(onTap: () => widget.onEmojiSelected(emoji), child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))))).toList(),
    );
  }

  Widget _buildStickerGrid() {
    final allStickers = [..._stickers, ..._customStickers];
    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(12),
      children: [
        // Botón + para crear sticker
        GestureDetector(
          onTap: _addCustomSticker,
          child: Container(margin: const EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: SeendColors.border, width: 1), borderRadius: BorderRadius.circular(12)), child: const Center(child: Icon(Icons.add, size: 32, color: SeendColors.primary))),
        ),
        // Stickers existentes
        ...allStickers.map((sticker) => GestureDetector(
          onTap: () => widget.onEmojiSelected(sticker),
          onLongPress: () {
            if (_customStickers.contains(sticker)) {
              setState(() => _customStickers.remove(sticker));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sticker eliminado'), backgroundColor: SeendColors.error, duration: Duration(seconds: 1)));
            }
          },
          child: Container(margin: const EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: SeendColors.border.withOpacity(0.3), width: 1), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(sticker, style: const TextStyle(fontSize: 36)))),
        )),
      ],
    );
  }

  Widget _buildStickerCreator() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        const Text('Selecciona un emoji para crear tu sticker', style: TextStyle(fontSize: 14, color: SeendColors.textSecondary)),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.count(
            crossAxisCount: 6,
            children: _emojis.take(30).map((emoji) => GestureDetector(
              onTap: () => _createStickerFromEmoji(emoji),
              child: Container(margin: const EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: SeendColors.primary.withOpacity(0.3)), borderRadius: BorderRadius.circular(8)), child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28)))),
            )).toList(),
          ),
        ),
        TextButton(onPressed: () => setState(() => _showStickerCreator = false), child: const Text('Cancelar')),
      ]),
    );
  }
}
