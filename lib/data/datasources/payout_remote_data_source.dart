import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';
import '../../core/utils/app_constants.dart';

abstract class PayoutRemoteDataSource {
  Future<Map<String, dynamic>> getPayoutHistory({
    required int page,
    required int limit,
  });
}

class PayoutRemoteDataSourceImpl implements PayoutRemoteDataSource {
  PayoutRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Map<String, dynamic>> getPayoutHistory({
    required int page,
    required int limit,
  }) async {
    final response = await _apiClient.get(
      AppConstants.myPayouts,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    if (kDebugMode) {
      try {
        final encoder = const JsonEncoder.withIndent('  ');
        final prettyJson = encoder.convert(response.data);
        debugPrint(
          '=== PAYOUT HISTORY API RESPONSE (Page $page) ===\n$prettyJson\n=========================================',
        );
      } catch (e) {
        debugPrint('Could not pretty print payouts response: $e');
      }
    }

    return response.data as Map<String, dynamic>;
  }
}
