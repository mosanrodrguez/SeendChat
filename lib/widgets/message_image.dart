import 'package:flutter/material.dart';
import '../config/colors.dart';

class MessageImage extends StatefulWidget {
  final String? imageUrl; final int? imageSize; final bool isMine;
  final bool isDownloaded; final bool isUploading; final double? uploadProgress;
  final VoidCallback? onDownload; final VoidCallback? onTap; final VoidCallback? onCancel;

  const MessageImage({super.key, this.imageUrl, this.imageSize, required this.isMine, this.isDownloaded = false, this.isUploading = false, this.uploadProgress, this.onDownload, this.onTap, this.onCancel});

  @override
  State<MessageImage> createState() => _MessageImageState();
}

class _MessageImageState extends State<MessageImage> {
  bool _isDownloading = false; double _progress = 0;

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = widget.isUploading || _isDownloading;
    final double progress = widget.uploadProgress ?? _progress;
    final int? size = widget.imageSize;

    return GestureDetector(
      onTap: widget.isDownloaded ? widget.onTap : (isLoading ? null : widget.onDownload),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(alignment: Alignment.center, children: [
          Container(width: 200, height: 200, color: Colors.grey[300], child: const Center(child: Icon(Icons.image, size: 48, color: Colors.grey))),
          if (!widget.isDownloaded && !widget.isUploading && size != null)
            Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(widget.isUploading ? Icons.upload : Icons.download, color: Colors.white, size: 16), const SizedBox(width: 6), Text(_formatSize(size), style: const TextStyle(color: Colors.white, fontSize: 12))])),
          if (isLoading)
            Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [SizedBox(width: 18, height: 18, child: CircularProgressIndicator(value: progress > 0 ? progress : null, strokeWidth: 2, color: SeendColors.primary)), const SizedBox(width: 8), if (size != null) Text(_formatSize((size * (1 - progress)).round()), style: const TextStyle(color: Colors.white, fontSize: 12)), if (widget.onCancel != null) ...[const SizedBox(width: 8), GestureDetector(onTap: widget.onCancel, child: const Icon(Icons.close, color: Colors.white, size: 16))]])),
        ]),
      ),
    );
  }
}
