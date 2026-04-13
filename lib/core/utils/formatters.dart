class Formatters {
  static String sanitizeUrl(String? value) {
    if (value == null) return '';

    final cleaned = value.replaceAll('\n', '').trim();
    return cleaned.replaceAll('<', '').replaceAll('>', '');
  }

  static double parseAmount(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value') ?? 0;
  }

  static int parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse('$value') ?? 0;
  }

  static DateTime? parseDateTime(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final normalized = value.trim().replaceFirst(' ', 'T');
    return DateTime.tryParse(normalized)?.toLocal();
  }
}
