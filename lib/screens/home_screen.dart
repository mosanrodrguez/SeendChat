import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/presence_provider.dart';
import '../config/colors.dart';
import '../models/chat_preview.dart';
import 'chat_screen.dart';
import 'group_chat_screen.dart';
import 'channel_chat_screen.dart';
import 'contacts_screen.dart';
import 'settings_screen.dart';
import '../widgets/empty_state.dart';
import '../widgets/avatar_with_badge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatProvider>().loadChats();
  }

  Future<void> _refresh() async => await context.read<ChatProvider>().loadChats();

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final auth = context.watch<AuthProvider>();
    final presence = context.watch<PresenceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          const Text('Seend', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: SeendColors.primary)),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(auth.fullName ?? '', style: const TextStyle(color: Colors.black, fontSize: 14)),
              const SizedBox(width: 8),
              AvatarWithBadge(name: auth.fullName ?? '?', type: ChatType.direct, size: 32, showOnline: true, isOnline: presence.isOnline),
            ]),
          ),
        ]),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: SeendColors.primary,
        child: chat.isLoading
            ? const Center(child: CircularProgressIndicator(color: SeendColors.primary))
            : chat.chats.isEmpty
                ? const EmptyState(icon: Icons.chat_bubble_outline, title: 'No hay conversaciones', subtitle: 'Toca el botón para iniciar un nuevo chat')
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: chat.chats.length,
                    itemBuilder: (_, i) {
                      final c = chat.chats[i];
                      final timeStr = c.lastMessageTime != null ? '${c.lastMessageTime!.hour.toString().padLeft(2, '0')}:${c.lastMessageTime!.minute.toString().padLeft(2, '0')}' : '';
                      return ListTile(
                        leading: AvatarWithBadge(name: c.displayName, photoUrl: c.photoUrl, type: c.type, size: 48),
                        title: Text(c.displayName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        subtitle: Row(children: [Expanded(child: Text(c.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)))]),
                        trailing: Column(children: [
                          Text(timeStr, style: const TextStyle(fontSize: 11, color: SeendColors.textSecondary)),
                          if (c.unreadCount > 0) ...[const SizedBox(height: 4), CircleAvatar(radius: 10, backgroundColor: SeendColors.primary, child: Text('${c.unreadCount}', style: const TextStyle(fontSize: 9, color: Colors.white)))],
                        ]),
                        onTap: () {
                          if (c.type == ChatType.direct) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(userId: c.userId!, userName: c.displayName, userPhoto: c.photoUrl)));
                          } else if (c.type == ChatType.group) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => GroupChatScreen(groupId: c.groupId!, groupName: c.displayName)));
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ChannelChatScreen(channelId: c.channelId!, channelName: c.displayName)));
                          }
                        },
                      );
                    },
                  ),
      ),
      floatingActionButton: Container(
        height: 48,
        decoration: BoxDecoration(color: SeendColors.primary, borderRadius: BorderRadius.circular(24)),
        child: Material(color: Colors.transparent, child: InkWell(borderRadius: BorderRadius.circular(24), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContactsScreen())), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.edit, color: Colors.white, size: 20), SizedBox(width: 6), Text('Nuevo chat', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))])))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
