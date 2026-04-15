class PayoutItem {
  const PayoutItem({
    required this.id,
    required this.payoutId,
    required this.deliveryPartnerId,
    required this.orderId,
    required this.amount,
    required this.deductAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int id;
  final int? payoutId;
  final int deliveryPartnerId;
  final int orderId;
  final double amount;
  final double deductAmount;
  final String status;
  final String createdAt;
  final String? updatedAt;
  final String? deletedAt;
}

class PayoutPageData {
  const PayoutPageData({
    required this.payouts,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  final List<PayoutItem> payouts;
  final int currentPage;
  final int totalPages;
  final int totalItems;
}
