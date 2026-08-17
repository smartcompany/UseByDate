import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_lib/share_lib_image_picker.dart';

import 'package:use_by_date/l10n/l10n_extensions.dart';
import 'package:use_by_date/services/camera_album_settings.dart';

/// Album picks and camera captures aligned with share_lib [MediaPickerService]
/// compression defaults (upload-friendly sizes).
class PhotoPickService {
  PhotoPickService._();

  static const int maxPhotos = 3;
  static const int compressMaxWidth = 1280;
  static const int compressMaxHeight = 720;
  static const int compressQuality = 65;

  static final ImagePicker _imagePicker = ImagePicker();

  /// Album grid picker (share_lib); returns up to [maxCount] compressed JPEG paths.
  static Future<List<String>> pickFromAlbum(
    BuildContext context, {
    int maxCount = maxPhotos,
  }) async {
    final limit = maxCount.clamp(1, maxPhotos);
    final files = await MediaPickerService.pickImages(
      context,
      maxCount: limit,
      compress: true,
      maxWidth: compressMaxWidth,
      maxHeight: compressMaxHeight,
      quality: compressQuality,
    );
    if (files == null || files.isEmpty) return const [];
    return [for (final file in files.take(limit)) file.path];
  }

  /// Opens the camera; returns the original file path (no compression yet).
  static Future<String?> pickCameraRaw() async {
    final picked = await _imagePicker.pickImage(source: ImageSource.camera);
    return picked?.path;
  }

  /// Album save + JPEG compression after [pickCameraRaw].
  static Future<String?> prepareCameraPhoto(
    BuildContext context,
    String pickedPath,
  ) async {
    if (await CameraAlbumSettings.isEnabled()) {
      await _saveToDeviceAlbum(pickedPath);
    }

    return _compressToJpeg(
      pickedPath,
      onFailure: () {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.imageCompressFailed)),
          );
        }
      },
    );
  }

  static Future<String?> captureFromCamera(BuildContext context) async {
    final pickedPath = await pickCameraRaw();
    if (pickedPath == null) return null;
    if (!context.mounted) return null;
    return prepareCameraPhoto(context, pickedPath);
  }

  static Future<void> _saveToDeviceAlbum(String path) async {
    try {
      var hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        hasAccess = await Gal.requestAccess(toAlbum: true);
      }
      if (!hasAccess) return;
      await Gal.putImage(path);
    } catch (error, stackTrace) {
      debugPrint('[PhotoPickService] save to album failed: $error');
      debugPrint('$stackTrace');
    }
  }

  static Future<String?> _compressToJpeg(
    String sourcePath, {
    void Function()? onFailure,
  }) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final compressed = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      quality: compressQuality,
      minWidth: compressMaxWidth,
      minHeight: compressMaxHeight,
    );

    if (compressed == null) {
      onFailure?.call();
      return null;
    }
    return compressed.path;
  }
}
