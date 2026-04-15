import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';
import '../../core/utils/app_constants.dart';

abstract class GigRemoteDataSource {
  Future<Map<String, dynamic>> getGigHistory({
    required int page,
    required int limit,
  });

  Future<Map<String, dynamic>> getGigByDate({
    required int page,
    required int limit,
    required String selectedDate,
  });
}

class GigRemoteDataSourceImpl implements GigRemoteDataSource {
  GigRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Map<String, dynamic>> getGigHistory({
    required int page,
    required int limit,
  }) async {
    final response = await _apiClient.get(
      AppConstants.gigHistory,
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
          '=== GIG HISTORY API RESPONSE (Page $page) ===\n$prettyJson\n=========================================',
        );
      } catch (e) {
        debugPrint('Could not pretty print gigs response: $e');
      }
    }

    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getGigByDate({
    required int page,
    required int limit,
    required String selectedDate,
  }) async {
    final response = await _apiClient.get(
      AppConstants.gigByDate,
      queryParameters: {
        'page': page,
        'limit': limit,
        'selectedDate': selectedDate,
      },
    );

    if (kDebugMode) {
      try {
        final encoder = const JsonEncoder.withIndent('  ');
        final prettyJson = encoder.convert(response.data);
        debugPrint(
          '=== GIG BY DATE API RESPONSE (Page $page, Date $selectedDate) ===\n$prettyJson\n=========================================',
        );
      } catch (e) {
        debugPrint('Could not pretty print gigs by date response: $e');
      }
    }

    return response.data as Map<String, dynamic>;
  }
}
