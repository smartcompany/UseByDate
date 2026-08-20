class AnalyzedExpiryItem {
  const AnalyzedExpiryItem({
    required this.name,
    this.imageId,
    this.expiryDate,
    this.expirySource,
    this.confidence,
    this.reason,
  });

  final String name;
  final String? imageId;
  final DateTime? expiryDate;
  final String? expirySource;
  final double? confidence;
  final String? reason;
}

class DraftProduct {
  DraftProduct({
    required this.name,
    this.sourceImagePath,
    this.expiryDate,
    this.expirySource,
    this.confidence,
    this.reason,
    this.notifyEnabled = true,
  });

  String name;
  String? sourceImagePath;
  DateTime? expiryDate;
  String? expirySource;
  double? confidence;
  String? reason;
  bool notifyEnabled;

  factory DraftProduct.fromAnalyzed(
    AnalyzedExpiryItem item, {
    String? sourceImagePath,
  }) {
    return DraftProduct(
      name: item.name,
      sourceImagePath: sourceImagePath,
      expiryDate: item.expiryDate,
      expirySource: item.expirySource,
      confidence: item.confidence,
      reason: item.reason,
    );
  }

  factory DraftProduct.manual({String? sourceImagePath}) {
    return DraftProduct(
      name: '',
      sourceImagePath: sourceImagePath,
      expirySource: 'user',
    );
  }
}

DateTime? parseIsoDate(String? raw) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return null;
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);
  if (match == null) return null;
  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  return DateTime(year, month, day);
}

String formatIsoDate(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String todayIsoDate() {
  final now = DateTime.now();
  return formatIsoDate(DateTime(now.year, now.month, now.day));
}

DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
