import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/presence_provider.dart';
import '../providers/call_provider.dart';
import '../config/colors.dart';
import '../models/message.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/emoji_picker.dart';
import 'call_screen.dart';
import 'contact_profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String? userPhoto;
  const ChatScreen({super.key, required this.userId, required this.userName, this.userPhoto});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  Message? _replyTo;
  bool _showEmoji = false;

  @override
  void initState() {
    super.initState();
    context.read<ChatProvider>().loadMessages(widget.userId);
  }

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    final msg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: context.read<AuthProvider>().userId ?? '',
      senderName: 'Tú',
      receiverId: widget.userId,
      text: text,
      status: 'sending',
      createdAt: DateTime.now(),
    );
    context.read<ChatProvider>().addMessageLocal(msg);
    context.read<ChatProvider>().sendMessage(widget.userId, text);
    _msgCtrl.clear();
    setState(() { _replyTo = null; _showEmoji = false; });
    Future.delayed(const Duration(milliseconds: 500), () => context.read<ChatProvider>().updateMessageStatus(msg.id, 'sent'));
    Future.delayed(const Duration(seconds: 2), () => context.read<ChatProvider>().updateMessageStatus(msg.id, 'delivered'));
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final messages = chat.messages[widget.userId] ?? [];
    final presence = context.watch<PresenceProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContactProfileScreen(userId: widget.userId, userName: widget.userName, userPhoto: widget.userPhoto))),
          child: Row(children: [
            CircleAvatar(radius: 16, backgroundColor: Colors.white24, child: Text(widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontSize: 12))),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.userName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
              Text(presence.getStatusText(widget.userId), style: const TextStyle(fontSize: 11, color: Colors.white70)),
            ]),
          ]),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call, color: Colors.white), onPressed: () {
            context.read<CallProvider>().startCall(widget.userId, widget.userName, callerPhoto: widget.userPhoto);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen()));
          }),
        ],
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
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final msg = messages[i];
                final isMe = msg.senderId == context.read<AuthProvider>().userId;
                return GestureDetector(
                  onLongPress: () => setState(() => _replyTo = msg),
                  child: ChatBubble(message: msg, isMine: isMe),
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
