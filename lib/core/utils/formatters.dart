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

  static String formatDateTime(DateTime? value, {String format = 'dd/MM/yyyy hh:mm a'}) {
    if (value == null) return '--';

    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final amPm = value.hour >= 12 ? 'PM' : 'AM';

    return format
        .replaceAll('dd', day)
        .replaceAll('MM', month)
        .replaceAll('yyyy', year)
        .replaceAll('hh', hour.toString())
        .replaceAll('mm', minute)
        .replaceAll('a', amPm);
  }
}
