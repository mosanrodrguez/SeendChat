import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../config/colors.dart';
import '../models/message.dart';
import '../widgets/chat_bubble.dart';
import 'channel_info_screen.dart';

class ChannelChatScreen extends StatefulWidget {
  final String channelId;
  final String channelName;
  const ChannelChatScreen({super.key, required this.channelId, required this.channelName});
  @override
  State<ChannelChatScreen> createState() => _ChannelChatScreenState();
}

class _ChannelChatScreenState extends State<ChannelChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChannelInfoScreen(channelId: widget.channelId, channelName: widget.channelName))),
          child: Row(children: [
            CircleAvatar(radius: 16, backgroundColor: Colors.white24, child: const Icon(Icons.campaign, color: Colors.white, size: 18)),
            const SizedBox(width: 8),
            Text(widget.channelName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
          ]),
        ),
      ),
      body: Center(child: Text('Mensajes del canal', style: TextStyle(fontSize: 14, color: SeendColors.textSecondary))),
    );
  }
}
