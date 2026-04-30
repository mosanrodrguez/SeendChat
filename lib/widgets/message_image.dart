import 'dart:io';
import 'package:flutter/material.dart';
import '../config/colors.dart';

class MessageImage extends StatefulWidget {
  final String? imageUrl;
  final int? imageSize;
  final bool isMine;
  final bool isDownloaded;
  final bool isUploading;
  final double? uploadProgress;
  final VoidCallback? onDownload;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const MessageImage({
    super.key,
    this.imageUrl,
    this.imageSize,
    required this.isMine,
    this.isDownloaded = false,
    this.isUploading = false,
    this.uploadProgress,
    this.onDownload,
    this.onTap,
    this.onCancel,
  });

  @override
  State<MessageImage> createState() => _MessageImageState();
}

class _MessageImageState extends State<MessageImage> {
  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isDownloaded ? widget.onTap : (widget.isUploading ? null : widget.onDownload),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Imagen
            if (widget.isDownloaded && widget.imageUrl != null)
              Image.network(widget.imageUrl!, width: 200, height: 200, fit: BoxFit.cover)
            else
              Container(
                width: 200, height: 200,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.image, size: 48, color: Colors.grey)),
              ),
            // Subiendo
            if (widget.isUploading)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white, value: widget.uploadProgress)),
                  const SizedBox(width: 8),
                  const Icon(Icons.upload, color: Colors.white, size: 16),
                ]),
              ),
            // Descargar
            if (!widget.isDownloaded && !widget.isUploading && widget.imageSize != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.download, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(_formatSize(widget.imageSize!), style: const TextStyle(color: Colors.white, fontSize: 12)),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}
