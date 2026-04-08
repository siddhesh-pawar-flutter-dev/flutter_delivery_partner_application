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
    return OrderHistoryPageModel.fromJson(response.data as Map<String, dynamic>);
  }
}
