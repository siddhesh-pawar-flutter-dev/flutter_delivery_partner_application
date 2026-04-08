import '../entities/delivery_order.dart';

abstract class OrderRepository {
  Future<OrderHistoryPage> getOrderHistory({
    required int page,
    required int limit,
  });
}
