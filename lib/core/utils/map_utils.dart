import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  static Future<void> openGoogleMaps({
    required double lat,
    required double lng,
  }) async {
    final Uri googleNavUri = Uri.parse(
      'google.navigation:q=$lat,$lng&mode=d',
    );

    final Uri geoUri = Uri.parse(
      'geo:$lat,$lng?q=$lat,$lng',
    );

    final Uri webUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );

    try {
      await launchUrl(
        googleNavUri,
        mode: LaunchMode.externalApplication,
      );
      return;
    } catch (_) {
      debugPrint('Google navigation failed, trying geo...');
    }

    try {
      await launchUrl(
        geoUri,
        mode: LaunchMode.externalApplication,
      );
      return;
    } catch (_) {
      debugPrint('Geo intent failed, trying web...');
    }

    try {
      await launchUrl(
        webUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('All map launch attempts failed: $e');
    }
  }
}