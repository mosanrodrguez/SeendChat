import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/presence_provider.dart';
import '../providers/call_provider.dart';
import '../config/colors.dart';
import '../models/chat_preview.dart';
import 'chat_screen.dart';
import 'group_chat_screen.dart';
import 'channel_chat_screen.dart';
import 'contacts_screen.dart';
import 'my_profile_screen.dart';
import 'status_list_screen.dart';
import 'call_screen.dart';
import '../widgets/incoming_call_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    context.read<ChatProvider>().loadChats();
    context.read<PresenceProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final call = context.watch<CallProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seend', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.qr_code_scanner, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.camera_alt_outlined, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyProfileScreen())),
            child: Container(
              width: 10, height: 10, margin: const EdgeInsets.all(15),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: SeendColors.online),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (call.state == CallState.ringing)
            IncomingCallPanel(
              callerName: call.callerName ?? '',
              callerPhoto: call.callerPhoto,
              onAccept: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen())),
              onReject: () => call.endCall(),
            ),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                _buildChatList(chat),
                const StatusListScreen(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _currentTab == 0
          ? FloatingActionButton(
              backgroundColor: SeendColors.primary,
              foregroundColor: Colors.white,
              mini: true,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsScreen())),
              child: const Icon(Icons.chat, size: 22),
            )
          : FloatingActionButton(
              backgroundColor: SeendColors.primary,
              foregroundColor: Colors.white,
              mini: true,
              onPressed: () {},
              child: const Icon(Icons.camera_alt, size: 22),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: SeendColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: 'Novedades'),
        ],
      ),
    );
  }

  Widget _buildChatList(ChatProvider chat) {
    if (chat.isLoading) return const Center(child: CircularProgressIndicator(color: SeendColors.primary));
    if (chat.chats.isEmpty) return Center(child: Text('No hay conversaciones', style: TextStyle(fontSize: 14, color: SeendColors.textSecondary)));
    return ListView.builder(
      itemCount: chat.chats.length,
      itemBuilder: (_, i) {
        final c = chat.chats[i];
        final timeStr = c.lastMessageTime != null
            ? '${c.lastMessageTime!.hour.toString().padLeft(2, '0')}:${c.lastMessageTime!.minute.toString().padLeft(2, '0')}'
            : '';
        IconData leadingIcon = Icons.person;
        if (c.type == ChatType.group) leadingIcon = Icons.group;
        if (c.type == ChatType.channel) leadingIcon = Icons.campaign;

        return ListTile(
          leading: CircleAvatar(radius: 24, backgroundColor: SeendColors.primary, child: Icon(leadingIcon, color: Colors.white, size: 22)),
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
    );
  }
}
