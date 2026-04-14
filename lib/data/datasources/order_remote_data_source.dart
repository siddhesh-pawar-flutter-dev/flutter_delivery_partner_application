import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';
import '../../core/utils/app_constants.dart';
import '../models/delivery_order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderHistoryPageModel> getOrderHistory({
    required int page,
    required int limit,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  OrderRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<OrderHistoryPageModel> getOrderHistory({
    required int page,
    required int limit,
  }) async {
    final response = await _apiClient.get(
      AppConstants.myOrders,
      queryParameters: {'page': page, 'limit': limit},
    );

    if (kDebugMode) {
      try {
        final encoder = const JsonEncoder.withIndent('  ');
        final prettyJson = encoder.convert(response.data);
        debugPrint(
          '=== ORDER DETAILS API RESPONSE (Page $page) ===\n$prettyJson\n=========================================',
        );
      } catch (e) {
        debugPrint('Could not pretty print orders response: $e');
      }
    }

    return OrderHistoryPageModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
