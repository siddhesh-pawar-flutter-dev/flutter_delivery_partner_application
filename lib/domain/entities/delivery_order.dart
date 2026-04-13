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
    required this.pickupAddress,
    required this.pickupTime,
    required this.paymentStatus,
    required this.deliveryType,
    required this.isCod,
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
  final String pickupAddress;
  final String pickupTime;
  final String paymentStatus;
  final String deliveryType;
  final bool isCod;
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
