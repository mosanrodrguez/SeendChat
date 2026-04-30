import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheService {
  static final DefaultCacheManager _cache = DefaultCacheManager();

  static Future<String?> getCachedPath(String url) async {
    try {
      final file = await _cache.getSingleFile(url);
      return file.path;
    } catch (_) {
      return null;
    }
  }

  static Future<void> preloadImages(List<String> urls) async {
    for (final url in urls) {
      try {
        await _cache.downloadFile(url);
      } catch (_) {}
    }
  }

  static Stream<FileResponse> getImageStream(String url) {
    return _cache.getFileStream(url);
  }

  static Future<void> clearCache() async {
    await _cache.emptyCache();
  }
}
