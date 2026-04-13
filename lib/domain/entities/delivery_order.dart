class DeliveryOrder {
  const DeliveryOrder({
    required this.id,
    required this.restaurantName,
    required this.amount,
    required this.status,
    required this.imageUrl,
    required this.createdAt,
    required this.itemSummary,
    required this.address,
    required this.pickupArea,
    required this.dropCity,
    required this.scheduledAt,
    required this.quantity,
  });

  final int id;
  final String restaurantName;
  final double amount;
  final String status;
  final String imageUrl;
  final String createdAt;
  final String itemSummary;
  final String address;
  final String pickupArea;
  final String dropCity;
  final String scheduledAt;
  final int quantity;
}

class OrderHistoryPage {
  const OrderHistoryPage({
    required this.orders,
    required this.currentPage,
    required this.totalPage,
    required this.totalItem,
  });

  final List<DeliveryOrder> orders;
  final int currentPage;
  final int totalPage;
  final int totalItem;
}
