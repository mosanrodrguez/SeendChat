import 'dart:io';
import 'package:flutter/material.dart';
import '../config/colors.dart';

class MessageImage extends StatefulWidget {
  final String imageUrl;
  final int imageSize;
  final bool isMine;
  final bool isDownloaded;
  final VoidCallback? onDownload;
  final VoidCallback? onTap;

  const MessageImage({
    super.key,
    required this.imageUrl,
    required this.imageSize,
    required this.isMine,
    this.isDownloaded = false,
    this.onDownload,
    this.onTap,
  });

  @override
  State<MessageImage> createState() => _MessageImageState();
}

class _MessageImageState extends State<MessageImage> {
  bool _isDownloading = false;

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isDownloaded ? widget.onTap : widget.onDownload,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Imagen
            widget.isDownloaded
                ? Image.network(
                    widget.imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image, size: 48, color: Colors.grey),
                    ),
                  ),
            // Botón de descarga (si no está descargada)
            if (!widget.isDownloaded)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isDownloading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.download, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      _formatSize(widget.imageSize),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
