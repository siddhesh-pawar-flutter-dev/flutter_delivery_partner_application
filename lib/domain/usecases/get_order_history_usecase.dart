import '../entities/delivery_order.dart';
import '../repositories/order_repository.dart';

class GetOrderHistoryUseCase {
  GetOrderHistoryUseCase(this._repository);

  final OrderRepository _repository;

  Future<OrderHistoryPage> call({
    required int page,
    required int limit,
  }) {
    return _repository.getOrderHistory(page: page, limit: limit);
  }
}
