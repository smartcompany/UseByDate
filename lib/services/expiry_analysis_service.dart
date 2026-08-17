import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:use_by_date/models/expiry_models.dart';
import 'package:use_by_date/services/api_settings_service.dart';
import 'package:use_by_date/services/photo_pick_service.dart';

class ExpiryAnalysisService {
  ExpiryAnalysisService({
    http.Client? client,
    ApiSettingsService? settings,
  })  : _client = client ?? http.Client(),
        _settings = settings ?? ApiSettingsService.shared;

  static const _maxBytes = 6 * 1024 * 1024;

  final http.Client _client;
  final ApiSettingsService _settings;

  Future<List<AnalyzedExpiryItem>> analyze(
    List<String> imagePaths, {
    required String targetLanguage,
    required String capturedAt,
  }) async {
    if (imagePaths.isEmpty) {
      throw StateError('At least one image is required');
    }
    final paths = imagePaths.take(PhotoPickService.maxPhotos).toList();

    final images = <Map<String, String>>[];
    for (final imagePath in paths) {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw StateError('Image file not found');
      }

      final bytes = await file.readAsBytes();
      if (bytes.length > _maxBytes) {
        throw StateError(
          'Image is too large for online analysis (${bytes.length} bytes).',
        );
      }

      images.add({
        'imageBase64': base64Encode(bytes),
        'mimeType': _mimeTypeForPath(imagePath),
      });
    }

    final baseUrl = await _settings.getApiBaseUrl();
    final uri = Uri.parse('$baseUrl/api/photos/analyze');

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'images': images,
        'contentLanguage': targetLanguage,
        'capturedAt': capturedAt,
      }),
    );

    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw StateError('Invalid server response (${response.statusCode})');
    }

    if (response.statusCode != 200) {
      final message = body['error'];
      final errorText = message is String && message.isNotEmpty
          ? message
          : 'Online analysis failed (${response.statusCode})';
      throw StateError(errorText);
    }

    final rawItems = body['items'];
    if (rawItems is! List) {
      throw StateError('Invalid items in server response');
    }

    final items = <AnalyzedExpiryItem>[];
    for (final entry in rawItems) {
      if (entry is! Map) continue;
      final name = entry['name'];
      if (name is! String || name.trim().isEmpty) continue;
      final source = entry['expirySource'];
      final confidence = entry['confidence'];
      final reason = entry['reason'];
      items.add(
        AnalyzedExpiryItem(
          name: name.trim(),
          expiryDate: parseIsoDate(entry['expiryDate'] as String?),
          expirySource: source is String ? source : null,
          confidence: confidence is num ? confidence.toDouble() : null,
          reason: reason is String ? reason.trim() : null,
        ),
      );
    }
    return items;
  }

  String _mimeTypeForPath(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.heic') || lower.endsWith('.heif')) {
      return 'image/heic';
    }
    return 'image/jpeg';
  }
}
