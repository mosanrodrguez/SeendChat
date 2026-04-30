import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  static final Map<String, dynamic> configuration = {
    'iceServers': [
      // STUN - Google (gratis)
      {
        'urls': [
          'stun:stun.l.google.com:19302',
          'stun:stun1.l.google.com:19302',
        ],
      },
      // TURN - OpenRelay (gratis, sin registro)
      {
        'urls': [
          'turn:openrelay.metered.ca:80',
          'turn:openrelay.metered.ca:443',
        ],
        'username': 'openrelayproject',
        'credential': 'openrelayproject',
      },
    ],
  };

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  RTCVideoRenderer? _localRenderer;
  RTCVideoRenderer? _remoteRenderer;

  RTCVideoRenderer? get localRenderer => _localRenderer;
  RTCVideoRenderer? get remoteRenderer => _remoteRenderer;
  RTCPeerConnection? get peerConnection => _peerConnection;

  Future<void> initializeCall({bool isVideo = false}) async {
    _localRenderer = RTCVideoRenderer();
    _remoteRenderer = RTCVideoRenderer();
    await _localRenderer!.initialize();
    await _remoteRenderer!.initialize();

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': isVideo
          ? {
              'facingMode': 'user',
              'width': {'ideal': 640},
              'height': {'ideal': 480},
              'frameRate': {'ideal': 30},
            }
          : false,
    });

    _localRenderer!.srcObject = _localStream;
    _peerConnection = await createPeerConnection(configuration);

    _localStream!.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    _peerConnection?.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        _remoteRenderer!.srcObject = event.streams[0];
      }
    };

    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
  }

  Future<void> answerCall(dynamic remoteOffer) async {
    if (remoteOffer is RTCSessionDescription) {
      await _peerConnection?.setRemoteDescription(remoteOffer);
      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
    }
  }

  void toggleMic() {
    _localStream?.getAudioTracks().forEach((track) => track.enabled = !track.enabled);
  }

  bool get isMicEnabled => _localStream?.getAudioTracks().any((t) => t.enabled) ?? false;

  void toggleCamera() {
    _localStream?.getVideoTracks().forEach((track) => track.enabled = !track.enabled);
  }

  bool get isCameraEnabled => _localStream?.getVideoTracks().any((t) => t.enabled) ?? false;

  Future<void> switchCamera() async {
    final videoTrack = _localStream?.getVideoTracks().first;
    if (videoTrack != null) await videoTrack.switchCamera();
  }

  Future<void> hangUp() async {
    _localStream?.getTracks().forEach((track) => track.stop());
    await _peerConnection?.close();
    _localRenderer?.dispose();
    _remoteRenderer?.dispose();
  }
}
