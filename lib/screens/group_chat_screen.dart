import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../config/colors.dart';
import '../models/message.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/emoji_picker.dart';
import 'group_info_screen.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  const GroupChatScreen({super.key, required this.groupId, required this.groupName});
  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _msgCtrl = TextEditingController();
  Message? _replyTo;
  bool _showEmoji = false;

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    final msg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: context.read<AuthProvider>().userId ?? '',
      senderName: 'Tú',
      receiverId: widget.groupId,
      text: text,
      status: 'sending',
      createdAt: DateTime.now(),
      isGroup: true,
      groupId: widget.groupId,
    );
    context.read<ChatProvider>().addMessageLocal(msg);
    _msgCtrl.clear();
    setState(() { _replyTo = null; _showEmoji = false; });
    Future.delayed(const Duration(milliseconds: 500), () => context.read<ChatProvider>().updateMessageStatus(msg.id, 'sent'));
    Future.delayed(const Duration(seconds: 2), () => context.read<ChatProvider>().updateMessageStatus(msg.id, 'delivered'));
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final messages = chat.messages[widget.groupId] ?? [];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GroupInfoScreen(groupId: widget.groupId, groupName: widget.groupName))),
          child: Row(children: [
            CircleAvatar(radius: 16, backgroundColor: Colors.white24, child: const Icon(Icons.group, color: Colors.white, size: 18)),
            const SizedBox(width: 8),
            Text(widget.groupName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
          ]),
        ),
      ),
      body: Column(
        children: [
          if (_replyTo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(children: [
                const Icon(Icons.reply, size: 16, color: SeendColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(child: Text(_replyTo!.text ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))),
                GestureDetector(onTap: () => setState(() => _replyTo = null), child: const Icon(Icons.close, size: 16, color: SeendColors.textSecondary)),
              ]),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final msg = messages[i];
                final isMe = msg.senderId == context.read<AuthProvider>().userId;
                return GestureDetector(
                  onLongPress: () => setState(() => _replyTo = msg),
                  child: Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      if (!isMe) Padding(padding: const EdgeInsets.only(left: 48, bottom: 2), child: Text(msg.senderName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: SeendColors.primary))),
                      ChatBubble(message: msg, isMine: isMe),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_showEmoji)
            EmojiPicker(
              onEmojiSelected: (emoji) => _msgCtrl.text += emoji,
              onClose: () => setState(() => _showEmoji = false),
            ),
          ChatInputBar(
            controller: _msgCtrl,
            onSend: _send,
            onAttach: () {},
            onEmoji: () => setState(() => _showEmoji = !_showEmoji),
          ),
        ],
      ),
    );
  }
}
