import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../providers/status_provider.dart';

class StatusViewerScreen extends StatefulWidget {
  final StatusItem status;
  const StatusViewerScreen({super.key, required this.status});
  @override
  State<StatusViewerScreen> createState() => _StatusViewerScreenState();
}

class _StatusViewerScreenState extends State<StatusViewerScreen> {
  final _replyCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.status.userName, style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text(widget.status.timeAgo, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 500),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.status.text != null)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(widget.status.text!, style: const TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Barra de respuesta
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Responde con un mensaje...',
                      hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: SeendColors.primary, size: 22),
                  onPressed: () {
                    if (_replyCtrl.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Respuesta enviada'), backgroundColor: SeendColors.primary, duration: Duration(seconds: 1)),
                      );
                      _replyCtrl.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
