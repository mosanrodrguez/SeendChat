import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/xmpp_provider.dart';
import '../providers/call_provider.dart';
import '../config/colors.dart';
import '../models/chat_preview.dart';
import 'chat_screen.dart';
import 'group_chat_screen.dart';
import 'channel_chat_screen.dart';
import 'contacts_screen.dart';
import 'my_profile_screen.dart';
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
    context.read<XmppProvider>().connect('user', 'pass');
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final xmpp = context.watch<XmppProvider>();
    final call = context.watch<CallProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          xmpp.isOnline ? 'Seend' : 'Conectando...',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Center(child: Text(auth.fullName ?? '', style: const TextStyle(color: Colors.white, fontSize: 13))),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyProfileScreen())),
            child: Container(
              width: 10, height: 10, margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: xmpp.isOnline ? SeendColors.online : SeendColors.error,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Panel de llamada entrante
          if (call.state == CallState.ringing)
            IncomingCallPanel(
              callerName: call.callerName ?? '',
              callerPhoto: call.callerPhoto,
              onAccept: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen())),
              onReject: () => call.endCall(),
            ),
          // Lista de chats
          Expanded(
            child: chat.isLoading
                ? const Center(child: CircularProgressIndicator(color: SeendColors.primary))
                : chat.chats.isEmpty
                    ? Center(child: Text('No hay conversaciones', style: TextStyle(fontSize: 14, color: SeendColors.textSecondary)))
                    : ListView.builder(
                        itemCount: chat.chats.length,
                        itemBuilder: (_, i) {
                          final c = chat.chats[i];
                          return _buildChatItem(c);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SeendColors.primary,
        foregroundColor: Colors.white,
        mini: true,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsScreen())),
        child: const Icon(Icons.add, size: 24),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.circle_outlined), activeIcon: Icon(Icons.circle), label: 'Estados'),
        ],
      ),
    );
  }

  Widget _buildChatItem(ChatPreview chat) {
    final timeStr = chat.lastMessageTime != null
        ? '${chat.lastMessageTime!.hour.toString().padLeft(2, '0')}:${chat.lastMessageTime!.minute.toString().padLeft(2, '0')}'
        : '';

    Widget statusIcon = const SizedBox.shrink();
    if (chat.type == ChatType.direct && chat.lastSenderName == 'Tú') {
      switch (chat.lastStatus) {
        case 'sending': statusIcon = const Icon(Icons.access_time, size: 14, color: SeendColors.checkGray); break;
        case 'sent': statusIcon = const Icon(Icons.check, size: 14, color: SeendColors.checkGray); break;
        case 'delivered': statusIcon = const Icon(Icons.done_all, size: 14, color: SeendColors.checkGray); break;
        case 'read': statusIcon = const Icon(Icons.done_all, size: 14, color: SeendColors.checkBlue); break;
      }
    } else if (chat.type == ChatType.group && chat.lastSenderName == 'Tú') {
      switch (chat.lastStatus) {
        case 'delivered': statusIcon = const Icon(Icons.done_all, size: 14, color: SeendColors.checkGray); break;
        case 'read': statusIcon = const Icon(Icons.visibility, size: 14, color: SeendColors.checkBlue); break;
      }
    }

    IconData leadingIcon = Icons.person;
    Color leadingBg = SeendColors.primary;
    if (chat.type == ChatType.group) { leadingIcon = Icons.group; leadingBg = SeendColors.primary; }
    if (chat.type == ChatType.channel) { leadingIcon = Icons.campaign; leadingBg = SeendColors.primary; }

    return ListTile(
      leading: CircleAvatar(radius: 24, backgroundColor: leadingBg, child: Icon(leadingIcon, color: Colors.white, size: 22)),
      title: Text(chat.displayName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      subtitle: Row(
        children: [
          if (chat.lastSenderName != null && chat.type == ChatType.group)
            Text('${chat.lastSenderName}: ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          Expanded(child: Row(children: [Expanded(child: Text(chat.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))), statusIcon])),
        ],
      ),
      trailing: Text(timeStr, style: const TextStyle(fontSize: 11, color: SeendColors.textSecondary)),
      onTap: () {
        if (chat.type == ChatType.direct) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(userId: chat.userId!, userName: chat.displayName, userPhoto: chat.photoUrl)));
        } else if (chat.type == ChatType.group) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => GroupChatScreen(groupId: chat.groupId!, groupName: chat.displayName)));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChannelChatScreen(channelId: chat.channelId!, channelName: chat.displayName)));
        }
      },
    );
  }
}
