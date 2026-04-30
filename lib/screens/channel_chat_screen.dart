import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../config/colors.dart';
import '../models/message.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/empty_state.dart';
import 'channel_info_screen.dart';

class ChannelChatScreen extends StatefulWidget {
  final String channelId; final String channelName;
  const ChannelChatScreen({super.key, required this.channelId, required this.channelName});
  @override
  State<ChannelChatScreen> createState() => _ChannelChatScreenState();
}

class _ChannelChatScreenState extends State<ChannelChatScreen> {
  final _scrollCtrl = ScrollController();
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    // Carga últimos 10 mensajes del canal
    context.read<ChatProvider>().loadMessages(widget.channelId, isChannel: true);
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels <= 50 && !_loadingMore) {
      final chat = context.read<ChatProvider>();
      if (chat.hasMoreMessages(widget.channelId)) {
        setState(() => _loadingMore = true);
        chat.loadChannelMessages(widget.channelId, loadMore: true).then((_) {
          setState(() => _loadingMore = false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final messages = chat.messages[widget.channelId] ?? [];
    final hasMore = chat.hasMoreMessages(widget.channelId);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChannelInfoScreen(channelId: widget.channelId, channelName: widget.channelName))),
          child: Row(children: [
            CircleAvatar(radius: 20, backgroundColor: Colors.white24, child: const Icon(Icons.campaign, color: Colors.white, size: 20)),
            const SizedBox(width: 10),
            Text(widget.channelName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          ]),
        ),
      ),
      body: Column(children: [
        if (_loadingMore)
          const Padding(padding: EdgeInsets.all(8), child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: SeendColors.primary)))),
        if (hasMore && !_loadingMore)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: TextButton.icon(
                onPressed: () => chat.loadChannelMessages(widget.channelId, loadMore: true),
                icon: const Icon(Icons.arrow_upward, size: 16, color: SeendColors.textSecondary),
                label: const Text('Cargar mensajes anteriores', style: TextStyle(fontSize: 12, color: SeendColors.textSecondary)),
              ),
            ),
          ),
        Expanded(
          child: messages.isEmpty
              ? const EmptyState(icon: Icons.campaign, title: 'Sin mensajes', subtitle: 'Este canal aún no tiene contenido')
              : ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final msg = messages[i];
                    final isMe = msg.senderId == context.read<AuthProvider>().userId;
                    return GestureDetector(
                      onLongPress: () {},
                      child: ChatBubble(message: msg, isMine: isMe),
                    );
                  },
                ),
        ),
      ]),
    );
  }
}
