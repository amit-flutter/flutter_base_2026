import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CacheManager {
  final Duration maxAge;
  final int maxSizeBytes;

  CacheManager({
    this.maxAge = const Duration(days: 7),
    this.maxSizeBytes = 50 * 1024 * 1024,
  });

  Future<Directory> get _cacheDir => getTemporaryDirectory();

  Future<File> file(String key) async {
    final dir = await _cacheDir;
    return File('${dir.path}/cache_$key');
  }

  Future<void> set(String key, List<int> data) async {
    final f = await file(key);
    await f.writeAsBytes(data);
  }

  Future<List<int>?> get(String key) async {
    final f = await file(key);
    if (!await f.exists()) return null;
    final modified = await f.lastModified();
    if (DateTime.now().difference(modified) > maxAge) {
      await f.delete();
      return null;
    }
    return f.readAsBytes();
  }

  Future<void> remove(String key) async {
    final f = await file(key);
    if (await f.exists()) await f.delete();
  }

  Future<void> clear() async {
    final dir = await _cacheDir;
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.contains('cache_')) {
        await entity.delete();
      }
    }
  }

  Future<int> size() async {
    final dir = await _cacheDir;
    var total = 0;
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.contains('cache_')) {
        total += await entity.length();
      }
    }
    return total;
  }
}
