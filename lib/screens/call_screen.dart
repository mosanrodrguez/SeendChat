import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/call_provider.dart';
import '../config/colors.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final call = context.watch<CallProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Avatar
            CircleAvatar(radius: 50, backgroundColor: Colors.white24, child: Text(call.callerName?.isNotEmpty == true ? call.callerName![0].toUpperCase() : '?', style: const TextStyle(fontSize: 36, color: Colors.white))),
            const SizedBox(height: 20),
            // Nombre
            Text(call.callerName ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            // Estado
            Text(
              call.state == CallState.calling ? 'Llamando...' :
              call.state == CallState.ringing ? 'Llamada entrante...' :
              call.state == CallState.connecting ? 'Conectando...' :
              call.state == CallState.inProgress ? call.formattedTime : '',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const Spacer(flex: 2),
            // Barra de botones
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (call.state == CallState.inProgress) ...[
                    _buildActionButton(
                      icon: call.isMicEnabled ? Icons.mic : Icons.mic_off,
                      color: call.isMicEnabled ? Colors.white24 : Colors.red,
                      onTap: () => call.toggleMic(),
                    ),
                    _buildActionButton(
                      icon: call.isSpeakerEnabled ? Icons.volume_up : Icons.volume_down,
                      color: call.isSpeakerEnabled ? Colors.white : Colors.white24,
                      onTap: () => call.toggleSpeaker(),
                    ),
                    _buildActionButton(
                      icon: call.isCameraEnabled ? Icons.videocam : Icons.videocam_off,
                      color: call.isCameraEnabled ? Colors.white : Colors.white24,
                      onTap: () => call.toggleCamera(),
                    ),
                    if (call.isCameraEnabled)
                      _buildActionButton(
                        icon: Icons.flip_camera_android,
                        color: Colors.white24,
                        onTap: () {},
                      ),
                  ],
                  if (call.state == CallState.ringing)
                    _buildActionButton(
                      icon: Icons.call,
                      color: SeendColors.online,
                      size: 60,
                      onTap: () => call.onConnected(),
                    ),
                  _buildActionButton(
                    icon: Icons.call_end,
                    color: SeendColors.error,
                    size: 60,
                    onTap: () { call.endCall(); Navigator.pop(context); },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required Color color, required VoidCallback onTap, double size = 48}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: IconButton(icon: Icon(icon, color: Colors.white, size: size * 0.45), onPressed: onTap, padding: EdgeInsets.zero),
    );
  }
}
