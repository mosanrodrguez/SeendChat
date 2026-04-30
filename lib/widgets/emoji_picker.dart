import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../config/colors.dart';

class EmojiPickerWidget extends StatefulWidget {
  final Function(String) onEmojiSelected;
  final VoidCallback onClose;
  final Function(String)? onStickerSelected;

  const EmojiPickerWidget({super.key, required this.onEmojiSelected, required this.onClose, this.onStickerSelected});

  @override
  State<EmojiPickerWidget> createState() => _EmojiPickerWidgetState();
}

class _EmojiPickerWidgetState extends State<EmojiPickerWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  final List<String> _customStickers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() => setState(() => _selectedTab = _tabController.index));
  }

  Future<void> _createCustomSticker() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxWidth: 512, maxHeight: 512);
    if (picked != null) {
      setState(() => _customStickers.add(picked.path));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sticker creado'), backgroundColor: SeendColors.primary, duration: Duration(seconds: 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final iconColor = isDark ? Colors.white70 : SeendColors.textSecondary;

    return Container(
      height: 340,
      decoration: BoxDecoration(color: bgColor, border: Border(top: BorderSide(color: SeendColors.border.withOpacity(0.3), width: 0.5))),
      child: Column(children: [
        Container(height: 44, padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: bgColor, border: Border(bottom: BorderSide(color: SeendColors.border.withOpacity(0.2), width: 0.5))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _buildTabIcon(Icons.emoji_emotions, 'Emojis', 0, iconColor), const SizedBox(width: 40), _buildTabIcon(Icons.star, 'Stickers', 1, iconColor),
        ])),
        Expanded(child: TabBarView(controller: _tabController, children: [
          // Emoji Picker simplificado (sin parámetros que no existen en esta versión)
          EmojiPicker(
            onEmojiSelected: (category, emoji) => widget.onEmojiSelected(emoji.emoji),
            onBackspacePressed: () {},
            config: const Config(checkPlatformCompatibility: true),
          ),
          _buildStickers(),
        ])),
      ]),
    );
  }

  Widget _buildTabIcon(IconData icon, String label, int index, Color iconColor) {
    final isActive = _selectedTab == index;
    return GestureDetector(onTap: () => _tabController.animateTo(index), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 22, color: isActive ? SeendColors.primary : iconColor), const SizedBox(height: 2), Text(label, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal, color: isActive ? SeendColors.primary : iconColor))]));
  }

  Widget _buildStickers() {
    return _customStickers.isEmpty
        ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.star_outline, size: 48, color: Colors.grey[400]), const SizedBox(height: 8), const Text('No tienes stickers', style: TextStyle(fontSize: 14, color: SeendColors.textSecondary)), const SizedBox(height: 12), ElevatedButton.icon(onPressed: _createCustomSticker, icon: const Icon(Icons.add, size: 18), label: const Text('Crear sticker'), style: ElevatedButton.styleFrom(backgroundColor: SeendColors.primary, foregroundColor: Colors.white))]))
        : GridView.count(crossAxisCount: 4, padding: const EdgeInsets.all(12), children: [
            GestureDetector(onTap: _createCustomSticker, child: Container(margin: const EdgeInsets.all(6), decoration: BoxDecoration(color: SeendColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: SeendColors.primary.withOpacity(0.3), width: 1)), child: const Center(child: Icon(Icons.add, size: 36, color: SeendColors.primary)))),
            ..._customStickers.asMap().entries.map((entry) => GestureDetector(onTap: () => widget.onStickerSelected?.call(entry.value), onLongPress: () { setState(() => _customStickers.removeAt(entry.key)); }, child: Container(margin: const EdgeInsets.all(6), decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: SeendColors.primary.withOpacity(0.3), width: 1)), child: ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.file(File(entry.value), fit: BoxFit.cover))))),
          ]);
  }
}
