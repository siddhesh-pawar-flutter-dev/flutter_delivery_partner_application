import '../../core/utils/formatters.dart';
import '../../domain/entities/delivery_order.dart';

class DeliveryOrderModel extends DeliveryOrder {
  const DeliveryOrderModel({
    required super.id,
    required super.restaurantName,
    required super.amount,
    required super.status,
    required super.imageUrl,
    required super.createdAt,
    required super.itemSummary,
    required super.address,
  });

  factory DeliveryOrderModel.fromJson(Map<String, dynamic> json) {
    final orderList = json['order'] as List<dynamic>? ?? [];
    final order = orderList.isNotEmpty
        ? orderList.first as Map<String, dynamic>
        : <String, dynamic>{};
    final restaurant = order['restaurant'] as Map<String, dynamic>? ?? {};
    final summary = order['order_summary'] as Map<String, dynamic>? ?? {};
    final restaurants = summary['restaurants'] as List<dynamic>? ?? [];
    final firstRestaurant = restaurants.isNotEmpty
        ? restaurants.first as Map<String, dynamic>
        : <String, dynamic>{};
    final items = firstRestaurant['menu_items'] as List<dynamic>? ?? [];
    final firstItem = items.isNotEmpty
        ? items.first as Map<String, dynamic>
        : <String, dynamic>{};
    final addressDetails = summary['address_details'] as Map<String, dynamic>? ?? {};

    return DeliveryOrderModel(
      id: Formatters.parseInt(json['order_id']),
      restaurantName: (restaurant['restaurant_name'] ?? 'Restaurant').toString(),
      amount: Formatters.parseAmount(order['grand_total'] ?? order['total_amount']),
      status: ((json['status'] ?? order['status']) ?? '').toString(),
      imageUrl: Formatters.sanitizeUrl(
        json['delivery_end_image']?.toString() ??
            json['order_pickup_image']?.toString(),
      ),
      createdAt: (json['createdAt'] ?? '').toString(),
      itemSummary: (firstItem['title'] ?? 'Order').toString(),
      address: (addressDetails['address_line_1'] ?? 'Address unavailable')
          .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': id,
      'restaurant_name': restaurantName,
      'amount': amount,
      'status': status,
      'image_url': imageUrl,
      'createdAt': createdAt,
      'item_summary': itemSummary,
      'address': address,
    };
  }
}

class OrderHistoryPageModel extends OrderHistoryPage {
  const OrderHistoryPageModel({
    required List<DeliveryOrderModel> super.orders,
    required super.currentPage,
    required super.totalPage,
    required super.totalItem,
  });

  factory OrderHistoryPageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final ordersJson = data['myOrders'] as List<dynamic>? ?? [];
    final pagination = data['pagination'] as Map<String, dynamic>? ?? {};

    return OrderHistoryPageModel(
      orders:
          ordersJson
              .map(
                (item) =>
                    DeliveryOrderModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      currentPage: Formatters.parseInt(pagination['page']),
      totalPage: Formatters.parseInt(pagination['totalPage']),
      totalItem: Formatters.parseInt(pagination['totalItem']),
    );
  }
}
