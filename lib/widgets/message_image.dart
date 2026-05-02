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
  bool _isDownloading = false;
  double _downloadProgress = 0;

  String _formatSize(int? bytes) {
    if (bytes == null) return '';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool get _isLoading => widget.isUploading || _isDownloading;
  double get _progress => widget.uploadProgress ?? _downloadProgress;

  @override
  Widget build(BuildContext context) {
    final size = widget.imageSize;
    final bool showInitialButton = !widget.isDownloaded && !widget.isUploading && !_isDownloading && size != null;
    final bool showProgress = _isLoading;
    final bool showCompleted = widget.isDownloaded && !_isLoading;

    return GestureDetector(
      onTap: showCompleted ? widget.onTap : (showInitialButton ? widget.onDownload : null),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Imagen de fondo
            if (widget.isUploading && widget.imageUrl != null && File(widget.imageUrl!).existsSync())
              Image.file(File(widget.imageUrl!), width: 200, height: 200, fit: BoxFit.cover)
            else if (widget.isDownloaded && widget.imageUrl != null)
              Image.network(widget.imageUrl!, width: 200, height: 200, fit: BoxFit.cover)
            else if (!widget.isUploading)
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Image.network(
                  widget.imageUrl ?? '',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 200, height: 200, color: Colors.grey[300], child: const Center(child: Icon(Icons.image, size: 48, color: Colors.grey))),
                ),
              ),

            // Overlay de subida/descarga (MISMO DISEÑO PARA AMBOS)
            if (showInitialButton)
              // Botón inicial (descarga o subida pendiente)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(widget.isUploading ? Icons.upload : Icons.download, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(_formatSize(size), style: const TextStyle(color: Colors.white, fontSize: 12)),
                ]),
              ),

            if (showProgress)
              // Progreso circular (MISMO DISEÑO PARA SUBIR Y DESCARGAR)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(
                      value: _progress > 0 ? _progress : null,
                      strokeWidth: 2,
                      color: SeendColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (size != null)
                    Text(
                      _formatSize((size * (1 - _progress)).round()),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  if (widget.onCancel != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.onCancel,
                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                  ],
                ]),
              ),
          ],
        ),
      ),
    );
  }
}
