import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageStore {
  ImageStore({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  static const photosSubdir = 'photos';

  Future<Directory> _photosDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, photosSubdir));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Copies [sourcePath] into app documents and returns a **relative** path
  /// (`photos/<uuid>.jpg`). Never store absolute paths — iOS container UUID
  /// changes on reinstall / many restarts.
  Future<String> persistImage(String sourcePath) async {
    final dir = await _photosDir();
    final source = File(sourcePath);
    final normalizedSource = p.normalize(sourcePath);
    final normalizedDir = p.normalize(dir.path);

    if (normalizedSource == normalizedDir ||
        p.isWithin(normalizedDir, normalizedSource)) {
      return p.join(photosSubdir, p.basename(sourcePath)).replaceAll('\\', '/');
    }

    if (!await source.exists()) {
      throw FileSystemException('Source image not found', sourcePath);
    }

    final ext =
        p.extension(sourcePath).isEmpty ? '.jpg' : p.extension(sourcePath);
    final fileName = '${_uuid.v4()}$ext';
    final destPath = p.join(dir.path, fileName);
    await source.copy(destPath);
    return p.join(photosSubdir, fileName);
  }

  Future<String> resolvePath(String stored) async {
    final trimmed = stored.trim();
    if (trimmed.isEmpty) return trimmed;

    final asStored = File(trimmed);
    if (p.isAbsolute(trimmed) && await asStored.exists()) {
      return trimmed;
    }

    final docs = await getApplicationDocumentsDirectory();
    final basename = p.basename(trimmed);

    final candidates = <String>[
      if (!p.isAbsolute(trimmed)) p.join(docs.path, trimmed),
      p.join(docs.path, photosSubdir, basename),
      p.join(docs.path, basename),
    ];

    for (final candidate in candidates) {
      if (await File(candidate).exists()) {
        return candidate;
      }
    }

    if (!p.isAbsolute(trimmed)) {
      return p.join(docs.path, trimmed);
    }
    return p.join(docs.path, photosSubdir, basename);
  }

  Future<void> deleteImage(String storedPath) async {
    final absolute = await resolvePath(storedPath);
    final file = File(absolute);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
