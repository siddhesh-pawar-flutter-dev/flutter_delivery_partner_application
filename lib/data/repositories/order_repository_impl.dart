import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/delivery_order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._remoteDataSource);

  final OrderRemoteDataSource _remoteDataSource;

  @override
  Future<OrderHistoryPage> getOrderHistory({
    required int page,
    required int limit,
  }) async {
    try {
      return await _remoteDataSource.getOrderHistory(page: page, limit: limit);
    } on AppException catch (error) {
      throw ServerFailure(error.message);
    }
  }
}
